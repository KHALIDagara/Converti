require "open-uri" # Required to download the avatar images
module LandingPages
    class FetchReviewsJob < ApplicationJob
      queue_as :default

      MAX_POLLING_ATTEMPTS = 60
      POLLING_INTERVAL = 2

      def speak
        puts "[FetchReviewsJob] hello ?? "
      end

      def perform(landing_page)
        puts "[FetchReviewsJob] :: Starting job for #{landing_page.id}"

        apify_service = ApifyService.new

        # 1. Start the Scraper
        response = apify_service.run_google_maps_scraper(
          url: landing_page.google_maps_url,
          max_reviews: 5,
          reviews_sort: "highestRanking"
        )

        run_id = response.dig("data", "id")
        dataset_id = response.dig("data", "defaultDatasetId")

        unless run_id && dataset_id
          raise StandardError, "Apify failed to start. Response: #{response}"
        end

        # 2. Poll until "SUCCEEDED"
        status = "RUNNING"
        attempts = 0

        while status != "SUCCEEDED"
          if attempts >= MAX_POLLING_ATTEMPTS
            raise StandardError, "Timeout waiting for Apify run #{run_id}"
          end

          sleep POLLING_INTERVAL

          status_response = apify_service.get_run_status(run_id)
          status = status_response.dig("data", "status")

          if [ "FAILED", "ABORTED", "TIMED-OUT" ].include?(status)
            raise StandardError, "Apify run failed: #{status}"
          end

          attempts += 1
        end

        # 3. Fetch Data
        puts "[FetchReviewsJob] :: Run finished. Downloading dataset..."
        items = apify_service.get_dataset(dataset_id)

        # 4. Save to Database
        process_reviews(landing_page, items)
      end

      private

      def process_reviews(landing_page, items)
        return if items.empty?

        # The Google Maps scraper often returns a 'Place' object containing a 'reviews' array.
        # We try to find that array first.
        # delete the current reviews
        landing_page.reviews.destroy_all
        reviews_data = if items.first && items.first["reviews"].is_a?(Array)
                        # Case A: Data is a Place object with nested reviews
                        items.first["reviews"]
        else
                        # Case B: Data is a flat list of reviews
                        items
        end

        reviews_data.each do |item|
          # Skip if content is empty (because your model validates presence: true)
          next if item["text"].blank?

          # Skip if this review already exists to prevent duplicates
          # (Assuming a combination of landing_page + author + content is unique)
          next if landing_page.reviews.exists?(name: item["name"], content: item["text"])

          review = landing_page.reviews.build(
            name: item["name"],
            content: item["text"],
            # rating: item['stars'] # Uncomment if you have a rating column
          )

          # 5. Handle Avatar Attachment
          if item["reviewerPhotoUrl"].present?
            begin
              # Open the URL and attach it
              downloaded_image = URI.open(item["reviewerPhotoUrl"])
              review.avatar.attach(
                io: downloaded_image,
                filename: "reviewer_#{review.object_id}.jpg",
                content_type: "image/jpeg"
              )
            rescue OpenURI::HTTPError => e
              puts "[FetchReviewsJob] :: Failed to download avatar for #{item['name']}: #{e.message}"
              # We continue without the avatar rather than failing the whole job
            end
          end

          if review.save
            puts "[FetchReviewsJob] :: Saved review by #{review.name}"
          else
            puts "[FetchReviewsJob] :: Validation errors: #{review.errors.full_messages}"
          end
        end
      end
    end
end

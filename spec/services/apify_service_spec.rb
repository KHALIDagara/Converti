require 'rails_helper'

RSpec.describe ApifyService do
  let(:service) { ApifyService.new }
  let(:test_url) { "https://www.google.com/maps/place/Rounane+service+rapid+auto/@33.571587,-7.6409375,15z/data=!4m10!1m2!2m1!1srapid+car!3m6!1s0xda7d2b06654e3df:0xb039fabea547ed3d!8m2!3d33.571587!4d-7.624458!15sCglyYXBpZCBjYXJaCyIJcmFwaWQgY2FykgELZ2FzX3N0YXRpb26aASRDaGREU1VoTk1HOW5TMFZKUTBGblNVTm9lRFJYZW14blJSQULgAQD6AQQIABBC!16s%2Fg%2F11g72fzpyh?entry=ttu&g_ep=EgoyMDI1MTIwOS4wIKXMDSoASAFQAw%3D%3D" }

  describe '#run_google_maps_scraper' do
    it 'successfully starts a scraping run', :vcr do
      result = service.run_google_maps_scraper(
        url: test_url,
        max_reviews: 6,
        reviews_sort: "highestRanking"
      )

      expect(result).to be_a(Hash)
      expect(result.dig("data", "id")).to be_present
      expect(result.dig("data", "status")).to be_in(["READY", "RUNNING", "SUCCEEDED"])
      expect(result.dig("data", "defaultDatasetId")).to be_present
    end
  end

  describe 'full workflow: scrape and retrieve reviews' do
    it 'scrapes Google Maps reviews and retrieves them', :vcr do
      # Step 1: Start the scraper
      puts "\n1. Starting Google Maps scraper..."
      result = service.run_google_maps_scraper(
        url: test_url,
        max_reviews: 6,
        reviews_sort: "highestRanking"
      )

      run_id = result.dig("data", "id")
      dataset_id = result.dig("data", "defaultDatasetId")

      expect(run_id).to be_present
      expect(dataset_id).to be_present

      puts "   Run ID: #{run_id}"
      puts "   Dataset ID: #{dataset_id}"

      # Step 2: Wait for completion and check status
      puts "\n2. Waiting for scraper to complete (max 60 seconds)..."
      status = "RUNNING"
      attempts = 0
      max_attempts = 12 # 60 seconds (5 second intervals)

      while status != "SUCCEEDED" && attempts < max_attempts
        sleep 5
        status_result = service.get_run_status(run_id)
        status = status_result.dig("data", "status")
        puts "   Status: #{status}"
        attempts += 1
      end

      expect(status).to eq("SUCCEEDED")

      # Step 3: Retrieve the scraped data
      puts "\n3. Retrieving reviews..."
      data = service.get_dataset(dataset_id)

      expect(data).to be_an(Array)
      expect(data.length).to be > 0

      # Display results
      puts "\n   ✓ Successfully retrieved #{data.length} item(s)"

      if data.length > 0
        # Check if data is array of reviews or place with nested reviews
        first_item = data[0]

        if first_item['reviews']
          # Case 1: Place object with nested reviews
          place = first_item
          puts "\n   Place Information:"
          puts "   - Name: #{place['title']}"
          puts "   - Category: #{place['categoryName']}"
          puts "   - Address: #{place['address']}"
          puts "   - Rating: #{place['totalScore']}"
          puts "   - Total Reviews: #{place['reviewsCount']}"

          if place['reviews'].length > 0
            puts "\n   Reviews (#{place['reviews'].length} fetched):"
            place['reviews'].first(3).each_with_index do |review, idx|
              puts "   #{idx + 1}. #{review['name']} - #{review['stars']} stars"
              puts "      #{review['text'][0..100]}..." if review['text']
            end
          end

          expect(place['title']).to be_present
          expect(place['totalScore']).to be_present
          expect(place['reviews']).to be_an(Array)
        elsif first_item['name'] && first_item['text']
          # Case 2: Each item is a review
          puts "\n   Reviews (#{data.length} fetched):"
          data.first(5).each_with_index do |review, idx|
            puts "\n   #{idx + 1}. #{review['name']} - #{review['stars']} ⭐"
            puts "      Published: #{review['publishedAtDate']}"
            puts "      #{review['text'][0..150]}..." if review['text'] && review['text'].length > 0
          end

          expect(first_item['name']).to be_present
          expect(first_item['stars']).to be_present
        else
          # Show structure for unknown format
          puts "\n   Data structure:"
          puts "   Keys: #{first_item.keys.join(', ')}"
        end
      end
    end
  end

  describe '#get_run_status' do
    it 'retrieves the status of a scraping run' do
      # First create a run
      result = service.run_google_maps_scraper(url: test_url, max_reviews: 3)
      run_id = result.dig("data", "id")

      # Then get its status
      status_result = service.get_run_status(run_id)

      expect(status_result).to be_a(Hash)
      expect(status_result.dig("data", "status")).to be_present
      expect(status_result.dig("data", "id")).to eq(run_id)
    end
  end

  describe '#get_dataset' do
    it 'retrieves data from a completed scraping run' do
      # This test would need a known completed dataset_id
      # For now, we test the method doesn't error
      result = service.run_google_maps_scraper(url: test_url, max_reviews: 1)
      dataset_id = result.dig("data", "defaultDatasetId")

      expect { service.get_dataset(dataset_id) }.not_to raise_error
    end
  end
end

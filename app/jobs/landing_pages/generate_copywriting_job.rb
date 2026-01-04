module LandingPages
    class GenerateCopywritingJob < ApplicationJob
      queue_as :default

      def perform(landing_page)
        # Do something later
        @business_details = landing_page.business_details
        @name = @business_details.dig("business_name")
        @description = @business_details.dig("business_description")
        @selling_points = @business_details.dig("selling_points")
        @keywords = @business_details.dig("keywords")
        @offer = @business_details.dig("offer")
        @audience = @business_details.dig("target_audience")

        puts "[GENERATE COPYWRITING JOB] :: the business #{@name} is #{@description} /n /n
        it's main selling points are #{@selling_points.each do |point| puts point end} and it's targetting #{@audience} with keywords #{@keywords.each do |keyword| puts keyword end} with offer #{@offer}
          "
      end
    end
end

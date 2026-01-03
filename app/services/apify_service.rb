require 'net/http'
require 'uri'
require 'json'

class ApifyService
  BASE_URL = "https://api.apify.com/v2"
  ACTOR_ID = "Xb8osYTtOjlsgI6k9"

  def initialize
    @api_token = ENV["APIFY_API_TOKEN"]
  end

  def run_google_maps_scraper(url:, max_reviews: 5, reviews_sort: "newest")
    input = {
      startUrls: [{ url: url }],
      maxReviews: max_reviews,
      reviewsSort: reviews_sort,
      language: "en",
      reviewsOrigin: "all",
      personalData: true
    }

    uri = URI("#{BASE_URL}/acts/#{ACTOR_ID}/runs?token=#{@api_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.path + "?" + uri.query)
    request["Content-Type"] = "application/json"
    request.body = input.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end

  def get_run_status(run_id)
    uri = URI("#{BASE_URL}/actor-runs/#{run_id}?token=#{@api_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    JSON.parse(response.body)
  end

  def get_dataset(dataset_id)
    uri = URI("#{BASE_URL}/datasets/#{dataset_id}/items?token=#{@api_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    JSON.parse(response.body)
  end
end

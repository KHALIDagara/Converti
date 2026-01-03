class AddReviewsColumnToLandingPages < ActiveRecord::Migration[8.0]
  def change
    add_column :landing_pages, :google_maps_url ,:string
  end
end

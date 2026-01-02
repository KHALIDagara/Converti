class AddBusinessDetailsToLandingPages < ActiveRecord::Migration[8.0]
  def change
    add_column :landing_pages, :business_details, :json
  end
end

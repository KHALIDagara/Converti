class FixLandingPageServiceRelationship < ActiveRecord::Migration[8.0]
  def change
      # Remove the wrong column from landing_pages
      remove_reference :landing_pages, :services, foreign_key: true
      # Add the correct column to services (singular)
      add_reference :services, :landing_page, null: false, foreign_key: true
  end
end

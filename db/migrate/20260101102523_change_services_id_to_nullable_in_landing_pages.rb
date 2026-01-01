class ChangeServicesIdToNullableInLandingPages < ActiveRecord::Migration[8.0]
  def change
  change_column_null :landing_pages, :services_id, true
  end
end

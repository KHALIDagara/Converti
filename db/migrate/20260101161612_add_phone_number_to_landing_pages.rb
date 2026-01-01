class AddPhoneNumberToLandingPages < ActiveRecord::Migration[8.0]
  def change
    add_column :landing_pages, :phone_number, :string
  end
end

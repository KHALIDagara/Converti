class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    drop_table :reviews, if_exists: true
    create_table :reviews do |t|
      t.string :name
      t.string :content
      t.references :landing_page, null: false, foreign_key: true

      t.timestamps
    end
  end
end

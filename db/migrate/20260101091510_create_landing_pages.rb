class CreateLandingPages < ActiveRecord::Migration[8.0]
  def change
    create_table :landing_pages do |t|
      t.string :title
      t.json :copywriting
      t.json :styles
      t.references :services, null: false, foreign_key: true

      t.timestamps
    end
  end
end

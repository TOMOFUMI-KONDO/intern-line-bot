class CreateThankings < ActiveRecord::Migration[6.0]
  def change
    create_table :thankings do |t|
      t.string :name
      t.string :url
      t.references :lending, null: false, foreign_key: true

      t.timestamps
    end
  end
end

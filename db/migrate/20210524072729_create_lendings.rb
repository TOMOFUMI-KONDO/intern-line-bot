class CreateLendings < ActiveRecord::Migration[6.0]
  def change
    create_table :lendings do |t|
      t.string :borrower_id, null: false
      t.string :lender_name, null: false
      t.string :content, null: false
      t.boolean :has_returned, null: false, default: false

      t.timestamps
    end
  end
end

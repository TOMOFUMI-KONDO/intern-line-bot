class CreateLendingThankings < ActiveRecord::Migration[6.0]
  def change
    create_table :lending_thankings do |t|
      t.references :lending, null: false, foreign_key: true
      t.references :thanking, null: false, foreign_key: true

      t.timestamps
    end

    change_table :thankings do |t|
      t.remove_references :lending
    end
  end
end

class CreateFuelLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :fuel_logs do |t|
      t.references :car, null: false, foreign_key: true
      t.date :fuel_date
      t.integer :odometer
      t.decimal :fuel_amount, precision: 5, scale: 2

      t.timestamps
    end
  end
end

class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :model

      t.timestamps
    end
  end
end

# Migration to create packs table
class CreatePacks < ActiveRecord::Migration[7.0]
  def change
    create_table :packs do |t|
      t.integer :price, null: false

      t.timestamps
    end
  end
end

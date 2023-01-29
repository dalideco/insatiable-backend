# Migration to create offers table
class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.integer :minimum_bid, null: false
      t.integer :current_bid
      t.integer :buy_now_price, null: false

      t.timestamps
    end
  end
end

# Migration to add players id to offers
# Many to one relationship between offers and players
class AddPlayerIdToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :player_id, :integer
  end
end

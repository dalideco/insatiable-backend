# Migration to add weapon id to offers
# Many to one relationship between offers and weapons
class AddWeaponIdToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :weapon_id, :integer
  end
end

# Migration to created own_pack table
# Many to many relationship between players and packs
class CreateOwnPacks < ActiveRecord::Migration[7.0]
  def change
    create_table :own_packs do |t|
      t.integer :player_id
      t.integer :pack_id

      t.timestamps default: Time.current
    end
  end
end

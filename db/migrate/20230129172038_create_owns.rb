# Migration to created owns table
# many_to_many relationship between weapons and players
class CreateOwns < ActiveRecord::Migration[7.0]
  def change
    create_table :owns do |t|
      t.integer :player_id
      t.integer :weapon_id

      t.timestamps
    end
  end
end

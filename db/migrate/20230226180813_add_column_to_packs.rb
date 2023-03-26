# Migration to add possible weapons to packs table
class AddColumnToPacks < ActiveRecord::Migration[7.0]
  def change
    add_column :packs, :title, :string, default: 'Pack'
    add_column :packs, :chance_common_weapon, :integer, default: 0
    add_column :packs, :chance_rare_weapon, :integer, default: 0
    add_column :packs, :chance_very_rare_weapon, :integer, default: 0
    add_column :packs, :chance_epic_weapon, :integer, default: 0
    add_column :packs, :chance_legendary_weapon, :integer, default: 0
  end
end

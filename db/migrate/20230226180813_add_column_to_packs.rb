# Migration to add possible weapons to packs table
class AddColumnToPacks < ActiveRecord::Migration[7.0]
  def change
    add_column :packs, :title, :string, default: 'Pack'
    add_column :packs, :nbr_common_weapons, :integer, default: 0
    add_column :packs, :nbr_rare_weapons, :integer, default: 0
    add_column :packs, :nbr_very_rare_weapons, :integer, default: 0
    add_column :packs, :nbr_epic_weapons, :integer, default: 0
    add_column :packs, :nbr_legendary_weapons, :integer, default: 0
  end
end

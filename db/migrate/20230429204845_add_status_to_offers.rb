# Migration to add status and lifetime column to offers
class AddStatusToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :status, :integer, default: 0
    add_column :offers, :lifetime, :integer, default: 0
  end
end

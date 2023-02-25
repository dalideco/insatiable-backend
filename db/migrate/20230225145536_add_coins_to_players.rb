# Migration add coins column to players table
class AddCoinsToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :coins, :integer, default: 1000
  end
end

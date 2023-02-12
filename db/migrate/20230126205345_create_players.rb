# Migration to created players table
class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :email, index: { unique: true }, null: false
      t.string :password_digest, null: false
      t.string :avatar, not_null: false
      t.datetime :confirmed_at, not_null: false

      t.timestamps default: Time.current
    end
  end
end

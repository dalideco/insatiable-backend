class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :email, index: { unique: true }
      t.string :password
      t.string :avatar, not_null: false
      t.timestamps
    end
  end
end

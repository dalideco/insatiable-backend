# Migration to created weapons table
class CreateWeapons < ActiveRecord::Migration[7.0]
  def change
    create_table :weapons do |t|
      t.string :image
      t.string :stats

      t.timestamps default: Time.current
    end
  end
end

class AddVariantToWeapons < ActiveRecord::Migration[7.0]
  def change
    add_column :weapons, :variant, :integer, default: 0
  end
end

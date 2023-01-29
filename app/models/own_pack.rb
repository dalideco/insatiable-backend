# own pack table model
class OwnPack < ApplicationRecord
  belongs_to :player, class_name: 'player'
  belongs_to :pack, class_name: 'pack'
end

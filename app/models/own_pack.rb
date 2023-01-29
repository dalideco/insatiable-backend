# own pack table model
class OwnPack < ApplicationRecord
  belongs_to :player
  belongs_to :pack
end

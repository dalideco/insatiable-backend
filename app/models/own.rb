# Own model
# many to many relationship between players and weapons
class Own < ApplicationRecord
  belongs_to :player, class_name: 'player'
  belongs_to :weapon, class_name: 'weapon'
end

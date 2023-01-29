# Own model
# many to many relationship between players and weapons
class Own < ApplicationRecord
  belongs_to :player
  belongs_to :weapon
end

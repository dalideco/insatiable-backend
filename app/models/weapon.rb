# weapon model
class Weapon < ApplicationRecord
  enum :variant, { common: 0, rare: 1, very_rare: 2, epic: 3, legendary: 4 }

  # one to many relationship with offers
  has_many :offers, class_name: 'offer', dependent: :delete_all
end

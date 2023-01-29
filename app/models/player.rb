# player model
class Player < ApplicationRecord
  # valdating
  validates :email, presence: true, uniqueness: { case_sensitive: false, strict: ::ActiveRecord::RecordNotUnique }
  validates :password, presence: true

  # relationshipt with weapons
  has_many :owns, dependent: :delete_all
  has_many :owned_weapons, through: :owns, source: :weapon

  # relationship with packs
  has_many :own_packs, dependent: :delete_all
  has_many :owned_packs, through: :own_packs, source: :pack

  # relationship with offers
  has_many :offers, dependent: :delete_all
end

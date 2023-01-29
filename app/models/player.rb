# player model
class Player < ApplicationRecord
  # valdating
  validates :email, presence: true, uniqueness: { case_sensitive: false, strict: ::ActiveRecord::RecordNotUnique }
  validates :password, presence: true

  # relationshipt with weapons
  has_many :owns, class_name: 'own', dependent: :delete_all
  has_many :owned_weapons, class_name: 'weapon', through: :owns, source: :weapon

  # relationship with packs
  has_many :own_packs, class_name: 'own_pack', dependent: :delete_all
  has_many :owned_packs, class_name: 'pack', through: :own_packs, source: :pack
end

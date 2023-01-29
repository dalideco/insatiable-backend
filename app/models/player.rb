# player model
class Player < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false, strict: ::ActiveRecord::RecordNotUnique }
  validates :password, presence: true
  has_many :owns, class_name: 'own', dependent: :delete_all
  has_many :owned_weapons, class_name: 'weapon', through: :owns, source: :weapon
end

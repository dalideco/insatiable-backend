# player model
class Player < ApplicationRecord
  before_save :downcase_email

  # valdating
  validates :email, presence: true, uniqueness: { case_sensitive: false, strict: ::ActiveRecord::RecordNotUnique },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true

  # relationshipt with weapons
  has_many :owns, dependent: :delete_all
  has_many :owned_weapons, through: :owns, source: :weapon

  # relationship with packs
  has_many :own_packs, dependent: :delete_all
  has_many :owned_packs, through: :own_packs, source: :pack

  # relationship with offers
  has_many :offers, dependent: :delete_all

  private

  def downcase_email
    self.email = email.downcase
  end
end

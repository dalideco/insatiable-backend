module V1
  # player model
  class Player < ApplicationRecord
    before_save :downcase_email

    has_secure_password

    # valdating
    validates :email, presence: true, uniqueness: { case_sensitive: false, strict: ::ActiveRecord::RecordNotUnique },
                      format: { with: URI::MailTo::EMAIL_REGEXP }

    # relationshipt with weapons
    has_many :owns, dependent: :delete_all
    has_many :owned_weapons, through: :owns, source: :weapon

    # relationship with packs
    has_many :own_packs, dependent: :delete_all
    has_many :owned_packs, through: :own_packs, source: :pack

    # relationship with offers
    has_many :offers, dependent: :delete_all

    # confirming player
    def confirm!
      update(confirmed_at: Time.current)
    end

    def confirmed?
      confirmed_at.present?
    end

    def generate_confirmation_token
      signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
    end

    def unconfirmed?
      !confirmed?
    end

    private

    def downcase_email
      self.email = email.downcase
    end
  end
end

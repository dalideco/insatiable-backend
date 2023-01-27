class Player < ApplicationRecord
    validates :email, presence: true, uniqueness: { case_sensitive: false, strict: ::ActiveRecord::RecordNotUnique }
    validates :password, presence: true
end

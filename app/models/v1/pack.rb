module V1
  # Pack model
  class Pack < ApplicationRecord
    validates :price, presence: true
  end
end

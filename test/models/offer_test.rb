require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  setup do
    @offer = offers(:one)
  end

  test 'verifying offers' do
    assert @offer
  end
end

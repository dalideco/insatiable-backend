require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  setup do
    @offer = offers(:one)
  end

  test 'testing fixtures' do
    assert @offer
  end
end

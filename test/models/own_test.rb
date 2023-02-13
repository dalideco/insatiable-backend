require 'test_helper'

class OwnTest < ActiveSupport::TestCase
  setup do
    @own = owns(:one)
  end

  test 'verifying player owns' do
    assert @own
  end
end

require 'test_helper'

class WeaponTest < ActiveSupport::TestCase
  setup do
    @weapon = weapons(:common_one)
  end

  test 'verifying weapons' do
    assert @weapon
  end
end

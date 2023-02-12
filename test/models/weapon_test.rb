require 'test_helper'

class WeaponTest < ActiveSupport::TestCase
  setup do
    @weapon = weapons(:one)
  end

  test 'verifying weapons' do
    assert @weapon
  end
end

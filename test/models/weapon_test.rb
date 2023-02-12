require 'test_helper'

class WeaponTest < ActiveSupport::TestCase
  setup do
    @weapon = weapons(:one)
  end

  test 'testing fixtures' do
    assert @weapon
  end
end

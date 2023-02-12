require "test_helper"

class OwnTest < ActiveSupport::TestCase
  setup do
    @own = owns(:one)
  end

  test 'testing fixtures' do
    assert @own
  end
end

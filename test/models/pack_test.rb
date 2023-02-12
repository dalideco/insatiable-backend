require 'test_helper'

class PackTest < ActiveSupport::TestCase
  setup do
    @pack = packs(:one)
  end

  test 'testing fixtures' do
    assert @pack
  end
end

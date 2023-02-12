require 'test_helper'

class PackTest < ActiveSupport::TestCase
  setup do
    @pack = packs(:one)
  end

  test 'verifying packs' do
    assert @pack
  end
end

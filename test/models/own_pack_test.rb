require 'test_helper'

class OwnPackTest < ActiveSupport::TestCase
  setup do
    @own_pack = own_packs(:one)
  end

  test 'testing fixtures' do
    assert @own_pack
  end
end

require "test_helper"

class V1::OwnPacksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_own_packs_index_url
    assert_response :success
  end

  test "should get create" do
    get v1_own_packs_create_url
    assert_response :success
  end

  test "should get show" do
    get v1_own_packs_show_url
    assert_response :success
  end

  test "should get update" do
    get v1_own_packs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get v1_own_packs_destroy_url
    assert_response :success
  end
end

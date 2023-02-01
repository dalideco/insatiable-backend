require "test_helper"

class V1::WeaponsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_weapons_index_url
    assert_response :success
  end

  test "should get show" do
    get v1_weapons_show_url
    assert_response :success
  end

  test "should get update" do
    get v1_weapons_update_url
    assert_response :success
  end

  test "should get delete" do
    get v1_weapons_delete_url
    assert_response :success
  end

  test "should get create" do
    get v1_weapons_create_url
    assert_response :success
  end
end

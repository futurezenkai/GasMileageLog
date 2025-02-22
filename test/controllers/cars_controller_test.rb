require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)  # fixtures/users.yml に :one というユーザーがある前提
    sign_in @user
  end

  test "should get new" do
    get new_car_url
    assert_response :success
  end

  test "should get create" do
    get cars_url
    assert_response :success
  end

  test "should get index" do
    get cars_url
    assert_response :success
  end
end

require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
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

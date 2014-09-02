require 'test_helper'

class SayControllerTest < ActionController::TestCase
  test "should get Hello" do
    get :Hello
    assert_response :success
  end

  test "should get World" do
    get :World
    assert_response :success
  end

end

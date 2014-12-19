require 'test_helper'

class PlayerControllerTest < ActionController::TestCase
  test "should get id" do
    get :id
    assert_response :success
  end

  test "should get hand" do
    get :hand
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get read" do
    get :read
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end

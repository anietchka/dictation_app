require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should create user with valid attributes" do
    assert_difference "User.count", 1 do
      post users_path, params: { user: { email: "newuser@example.com", password: "password123", password_confirmation: "password123" } }
    end

    assert_redirected_to dictations_path
    assert_not_nil session[:user_id]
  end

  test "should not create user with invalid attributes" do
    assert_no_difference "User.count" do
      post users_path, params: { user: { email: "invalid-email", password: "short", password_confirmation: "short" } }
    end

    assert_response :unprocessable_entity
  end
end

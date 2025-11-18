require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should get new" do
    get new_session_path
    assert_response :success
  end

  test "should create session with valid credentials" do
    post sessions_path, params: { email: @user.email, password: "password123" }
    assert_redirected_to root_path
    assert_equal @user.id, session[:user_id]
  end

  test "should not create session with invalid credentials" do
    post sessions_path, params: { email: @user.email, password: "wrongpassword" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should destroy session" do
    post sessions_path, params: { email: @user.email, password: "password123" }
    assert_equal @user.id, session[:user_id]

    delete logout_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end

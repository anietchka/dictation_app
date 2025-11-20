require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create user with valid attributes" do
    user = User.new(email: "test@example.com", password: "password123", password_confirmation: "password123")
    assert user.valid?
    assert user.save
  end

  test "should not create user without email" do
    user = User.new(password: "password123", password_confirmation: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], I18n.t("activerecord.errors.models.user.attributes.email.blank")
  end

  test "should not create user with invalid email" do
    user = User.new(email: "invalid-email", password: "password123", password_confirmation: "password123")
    assert_not user.valid?
  end

  test "should not create user with duplicate email" do
    User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    user = User.new(email: "test@example.com", password: "password123", password_confirmation: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], I18n.t("activerecord.errors.models.user.attributes.email.taken")
  end

  test "should not create user with short password" do
    user = User.new(email: "test@example.com", password: "short", password_confirmation: "short")
    assert_not user.valid?
    assert_includes user.errors[:password], I18n.t("activerecord.errors.models.user.attributes.password.too_short")
  end

  test "should authenticate user with correct password" do
    user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
    assert user.authenticate("password123")
    assert_not user.authenticate("wrongpassword")
  end
end

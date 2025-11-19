require "test_helper"

class DictationTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
  end

  test "should create dictation with valid attributes" do
    dictation = Dictation.new(
      user: @user,
      min_words: 50,
      max_words: 100,
      level: "CE1"
    )
    assert dictation.valid?
    assert dictation.save
  end

  test "should not create dictation without user" do
    dictation = Dictation.new(min_words: 50, max_words: 100)
    assert_not dictation.valid?
    assert_includes dictation.errors[:user], I18n.t("activerecord.errors.models.dictation.attributes.user.required")
  end

  test "should create dictation without min_words" do
    dictation = Dictation.new(user: @user, max_words: 100)
    assert dictation.valid?
    assert dictation.save
  end

  test "should create dictation without max_words" do
    dictation = Dictation.new(user: @user, min_words: 50)
    assert dictation.valid?
    assert dictation.save
  end

  test "should create dictation without min_words and max_words" do
    dictation = Dictation.new(user: @user)
    assert dictation.valid?
    assert dictation.save
  end

  test "should not create dictation with min_words less than or equal to zero" do
    dictation = Dictation.new(user: @user, min_words: 0, max_words: 100)
    assert_not dictation.valid?
    assert_includes dictation.errors[:min_words], I18n.t("activerecord.errors.models.dictation.attributes.min_words.greater_than")
  end

  test "should not create dictation with max_words less than or equal to zero" do
    dictation = Dictation.new(user: @user, min_words: 50, max_words: 0)
    assert_not dictation.valid?
    assert_includes dictation.errors[:max_words], I18n.t("activerecord.errors.models.dictation.attributes.max_words.greater_than")
  end

  test "should not create dictation with max_words less than min_words" do
    dictation = Dictation.new(user: @user, min_words: 100, max_words: 50)
    assert_not dictation.valid?
    assert_includes dictation.errors[:max_words], I18n.t("activerecord.errors.models.dictation.attributes.max_words.must_be_greater_than_min_words")
  end

  test "should create dictation with max_words equal to min_words" do
    dictation = Dictation.new(user: @user, min_words: 50, max_words: 50)
    assert dictation.valid?
    assert dictation.save
  end

  test "should not create dictation with non-integer min_words" do
    dictation = Dictation.new(user: @user, min_words: 50.5, max_words: 100)
    assert_not dictation.valid?
    assert_includes dictation.errors[:min_words], I18n.t("activerecord.errors.models.dictation.attributes.min_words.not_an_integer")
  end

  test "should not create dictation with non-integer max_words" do
    dictation = Dictation.new(user: @user, min_words: 50, max_words: 100.5)
    assert_not dictation.valid?
    assert_includes dictation.errors[:max_words], I18n.t("activerecord.errors.models.dictation.attributes.max_words.not_an_integer")
  end

  test "for_user scope should filter dictations by user" do
    user1 = User.create!(email: "scope_user1@example.com", password: "password123", password_confirmation: "password123")
    user2 = User.create!(email: "scope_user2@example.com", password: "password123", password_confirmation: "password123")

    dictation1 = Dictation.create!(user: user1, min_words: 50, max_words: 100)
    dictation2 = Dictation.create!(user: user2, min_words: 50, max_words: 100)
    dictation3 = Dictation.create!(user: user1, min_words: 100, max_words: 200)

    user1_dictations = Dictation.for_user(user1)
    assert_equal 2, user1_dictations.count
    assert_includes user1_dictations, dictation1
    assert_includes user1_dictations, dictation3
    assert_not_includes user1_dictations, dictation2

    user2_dictations = Dictation.for_user(user2)
    assert_equal 1, user2_dictations.count
    assert_includes user2_dictations, dictation2
  end

  test "should destroy dictations when user is destroyed" do
    dictation = Dictation.create!(user: @user, min_words: 50, max_words: 100)
    dictation_id = dictation.id

    @user.destroy

    assert_not Dictation.exists?(dictation_id)
  end
end

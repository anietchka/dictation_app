require "test_helper"

module Dictations
  class GenerateTest < ActiveSupport::TestCase
    def setup
      @user = User.create!(email: "test@example.com", password: "password123", password_confirmation: "password123")
      @dictation = Dictation.new(
        user: @user,
        level: "CE1",
        min_words: 50,
        max_words: 100,
        requested_words: "maison, école",
        requested_rules: "accord du participe passé"
      )
      @mock_client = MockOpenAiClient.new
    end

    test "should initialize with dictation" do
      service = Generate.new(@dictation, client: @mock_client)
      assert_not_nil service
    end

    test "should build system prompt from i18n" do
      service = Generate.new(@dictation, client: @mock_client)
      prompt = service.send(:system_prompt)

      assert_includes prompt, "expert"
      assert_includes prompt, "pédagogie"
      assert_includes prompt, "dictées"
    end

    test "should build user prompt with level" do
      service = Generate.new(@dictation, client: @mock_client)
      prompt = service.send(:user_prompt)

      assert_includes prompt, "CE1"
      assert_includes prompt, I18n.t("dictations.generate.user_prompt_level", level: "CE1")
    end

    test "should build user prompt with word count between" do
      service = Generate.new(@dictation, client: @mock_client)
      prompt = service.send(:user_prompt)

      assert_includes prompt, "50"
      assert_includes prompt, "100"
      assert_includes prompt, "entre"
    end

    test "should build user prompt with min words only" do
      dictation = Dictation.new(user: @user, level: "CE2", min_words: 75)
      service = Generate.new(dictation, client: @mock_client)
      prompt = service.send(:user_prompt)

      assert_includes prompt, "75"
      assert_includes prompt, "au moins"
    end

    test "should build user prompt with max words only" do
      dictation = Dictation.new(user: @user, level: "CE2", max_words: 150)
      service = Generate.new(dictation, client: @mock_client)
      prompt = service.send(:user_prompt)

      assert_includes prompt, "150"
      assert_includes prompt, "au plus"
    end

    test "should build user prompt with requested words" do
      service = Generate.new(@dictation, client: @mock_client)
      prompt = service.send(:user_prompt)

      assert_includes prompt, "maison"
      assert_includes prompt, "école"
    end

    test "should build user prompt with requested rules" do
      service = Generate.new(@dictation, client: @mock_client)
      prompt = service.send(:user_prompt)

      assert_includes prompt, "accord du participe passé"
    end

    test "should build user prompt without optional fields" do
      dictation = Dictation.new(user: @user, level: "CM1")
      service = Generate.new(dictation, client: @mock_client)
      prompt = service.send(:user_prompt)

      assert_includes prompt, "CM1"
      assert_not_includes prompt, "mots"
      assert_not_includes prompt, "maison"
    end

    test "should build messages array correctly" do
      service = Generate.new(@dictation, client: @mock_client)
      messages = service.send(:build_messages)

      assert_equal 2, messages.length
      assert_equal "system", messages[0][:role]
      assert_equal "user", messages[1][:role]
      assert_not_nil messages[0][:content]
      assert_not_nil messages[1][:content]
    end

    test "should clean content from AI prefixes and explanations" do
      service = Generate.new(@dictation, client: @mock_client)

      # Test with prefix
      content_with_prefix = "Voici la dictée :\n\nLe chat dort."
      cleaned = service.send(:clean_content, content_with_prefix)
      assert_equal "Le chat dort.", cleaned

      # Test with explanation at the end
      content_with_explanation = "Le chat dort.\n\nNote: Cette dictée contient..."
      cleaned = service.send(:clean_content, content_with_explanation)
      assert_equal "Le chat dort.", cleaned

      # Test with markdown
      content_with_markdown = "**Dictée**\n\nLe chat dort."
      cleaned = service.send(:clean_content, content_with_markdown)
      assert_equal "Le chat dort.", cleaned

      # Test normal content (should remain unchanged)
      normal_content = "Le chat dort paisiblement dans le jardin."
      cleaned = service.send(:clean_content, normal_content)
      assert_equal normal_content, cleaned
    end
  end

  # Mock client for testing
  class MockOpenAiClient
    def chat_completion(*)
      { "choices" => [ { "message" => { "content" => "Mock dictation content" } } ] }
    end
  end
end

require "test_helper"

module OpenAi
  class ClientTest < ActiveSupport::TestCase
    def setup
      @api_key = "test-api-key"
      @original_key = ENV["OPENAI_API_KEY"]
    end

    def teardown
      ENV["OPENAI_API_KEY"] = @original_key
    end

    test "should raise error when api_key is blank" do
      ENV.delete("OPENAI_API_KEY")
      assert_raises(ArgumentError) do
        Client.new(api_key: nil)
      end
    end

    test "should raise error when api_key is empty string" do
      ENV.delete("OPENAI_API_KEY")
      assert_raises(ArgumentError) do
        Client.new(api_key: "")
      end
    end

    test "should initialize with provided api_key" do
      client = Client.new(api_key: @api_key)
      assert_not_nil client
    end

    test "should initialize with ENV api_key when not provided" do
      original_key = ENV["OPENAI_API_KEY"]
      ENV["OPENAI_API_KEY"] = "env-api-key"

      client = Client.new
      assert_not_nil client

      ENV["OPENAI_API_KEY"] = original_key
    end

    test "should use default model" do
      client = Client.new(api_key: @api_key)
      assert_equal "gpt-4o-mini", Client::DEFAULT_MODEL
    end

    test "should have correct API URL" do
      assert_equal "https://api.openai.com/v1/chat/completions", Client::API_URL
    end
  end
end

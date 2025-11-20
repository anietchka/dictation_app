module OpenAi
  class Client
    API_URL = "https://api.openai.com/v1/chat/completions"
    DEFAULT_MODEL = "gpt-4o-mini"

    def initialize(api_key: nil)
      @api_key = api_key || ENV["OPENAI_API_KEY"]
      raise ArgumentError, I18n.t("open_ai.errors.api_key_required") if @api_key.blank?
    end

    def chat_completion(messages:, model: DEFAULT_MODEL, temperature: 0.7)
      response = http_client.post(API_URL) do |request|
        request.headers["Authorization"] = "Bearer #{@api_key}"
        request.headers["Content-Type"] = "application/json"
        request.body = {
          model: model,
          messages: messages,
          temperature: temperature
        }.to_json
      end

      handle_response(response)
    end

    private

    def http_client
      @http_client ||= Faraday.new do |conn|
        conn.request :json
        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      case response.status
      when 200
        parse_success_response(response.body)
      when 401
        raise AuthenticationError, I18n.t("open_ai.errors.invalid_api_key")
      when 429
        raise RateLimitError, I18n.t("open_ai.errors.rate_limit_exceeded")
      when 500..599
        raise ServerError, I18n.t("open_ai.errors.server_error")
      else
        error_message = response.body.dig("error", "message") || I18n.t("open_ai.errors.unknown_error")
        raise ApiError, I18n.t("open_ai.errors.api_error", message: error_message)
      end
    end

    def parse_success_response(body)
      content = body.dig("choices", 0, "message", "content")
      raise ApiError, I18n.t("open_ai.errors.no_content") if content.blank?

      content.strip
    end

    # Custom exceptions
    class ApiError < StandardError; end
    class AuthenticationError < ApiError; end
    class RateLimitError < ApiError; end
    class ServerError < ApiError; end
  end
end

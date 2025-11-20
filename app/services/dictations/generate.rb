module Dictations
  class Generate
    def initialize(dictation, client: nil)
      @dictation = dictation
      @client = client || OpenAi::Client.new
    end

    def call
      raw_content = @client.chat_completion(
        messages: build_messages,
        temperature: 0.7
      )

      content = clean_content(raw_content)

      { success: true, content: content }
    rescue OpenAi::Client::ApiError => e
      { success: false, error: e.message }
    end

    private

    def build_messages
      [
        {
          role: "system",
          content: system_prompt
        },
        {
          role: "user",
          content: user_prompt
        }
      ]
    end

    def system_prompt
      I18n.t("dictations.generate.system_prompt")
    end

    def user_prompt
      prompt_parts = []
      prompt_parts << I18n.t("dictations.generate.user_prompt_level", level: @dictation.level) if @dictation.level.present?

      if @dictation.min_words.present? || @dictation.max_words.present?
        word_count_text = if @dictation.min_words.present? && @dictation.max_words.present?
                            I18n.t("dictations.generate.user_prompt_word_count_between", min_words: @dictation.min_words, max_words: @dictation.max_words)
        elsif @dictation.min_words.present?
                            I18n.t("dictations.generate.user_prompt_word_count_min", min_words: @dictation.min_words)
        else
                            I18n.t("dictations.generate.user_prompt_word_count_max", max_words: @dictation.max_words)
        end
        prompt_parts << word_count_text
      end

      if @dictation.min_sentences.present? || @dictation.max_sentences.present?
        sentence_count_text = if @dictation.min_sentences.present? && @dictation.max_sentences.present?
                                I18n.t("dictations.generate.user_prompt_sentence_count_between", min_sentences: @dictation.min_sentences, max_sentences: @dictation.max_sentences)
        elsif @dictation.min_sentences.present?
                                I18n.t("dictations.generate.user_prompt_sentence_count_min", min_sentences: @dictation.min_sentences)
        else
                                I18n.t("dictations.generate.user_prompt_sentence_count_max", max_sentences: @dictation.max_sentences)
        end
        prompt_parts << sentence_count_text
      end

      if @dictation.requested_words.present?
        words = @dictation.requested_words.split(",").map(&:strip).join(", ")
        prompt_parts << I18n.t("dictations.generate.user_prompt_requested_words", words: words)
      end

      if @dictation.requested_rules.present?
        prompt_parts << I18n.t("dictations.generate.user_prompt_requested_rules", rules: @dictation.requested_rules)
      end

      prompt_parts << I18n.t("dictations.generate.user_prompt_final")

      prompt_parts.join(" ")
    end

    def clean_content(content)
      # Remove markdown formatting first (before other cleaning)
      content = content.gsub(/^\*\*/, "")
      content = content.gsub(/\*\*$/, "")
      content = content.gsub(/^#+\s*/, "")
      # Remove common prefixes that AI might add (case insensitive, multiline)
      # Match "Voici la dictée :" or "Dictée :" at the start, optionally followed by newlines
      content = content.gsub(/^(Voici|Voilà|Voici la dictée|Dictée|Texte de dictée)[\s:]*\n*/i, "")
      # Also handle "la dictée :" that might remain (case insensitive)
      content = content.gsub(/^la dictée[\s:]*\n*/i, "")
      # Remove standalone "Dictée" at the start (case insensitive)
      content = content.gsub(/^Dictée\s*\n*/i, "")
      # Remove explanations at the end (lines starting with "Note:", "Remarque:", etc.)
      content = content.gsub(/\n\s*(Note|Remarque|Explication|Attention)[\s:].*$/mi, "")
      # Remove any leading/trailing whitespace and newlines
      content.strip
    end
  end
end

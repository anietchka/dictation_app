class Dictation < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :min_words, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :max_words, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :min_sentences, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :max_sentences, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validate :max_words_greater_than_min_words
  validate :max_sentences_greater_than_min_sentences

  scope :for_user, ->(user) { where(user:) }

  private

  def max_words_greater_than_min_words
    return unless min_words.present? && max_words.present?

    errors.add(:max_words, :must_be_greater_than_min_words) if max_words < min_words
  end

  def max_sentences_greater_than_min_sentences
    return unless min_sentences.present? && max_sentences.present?

    errors.add(:max_sentences, :must_be_greater_than_min_sentences) if max_sentences < min_sentences
  end
end

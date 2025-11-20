class Dictation < ApplicationRecord
  belongs_to :user

  validates :min_words, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :max_words, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validate :max_words_greater_than_min_words

  scope :for_user, ->(user) { where(user:) }

  private

  def max_words_greater_than_min_words
    return unless min_words.present? && max_words.present?

    errors.add(:max_words, :must_be_greater_than_min_words) if max_words < min_words
  end
end

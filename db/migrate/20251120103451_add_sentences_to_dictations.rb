class AddSentencesToDictations < ActiveRecord::Migration[8.1]
  def change
    add_column :dictations, :min_sentences, :integer
    add_column :dictations, :max_sentences, :integer
  end
end

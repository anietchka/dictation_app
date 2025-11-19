class CreateDictations < ActiveRecord::Migration[8.1]
  def change
    create_table :dictations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :min_words
      t.integer :max_words
      t.string :level
      t.text :requested_words
      t.text :requested_rules
      t.text :content

      t.timestamps
    end
  end
end

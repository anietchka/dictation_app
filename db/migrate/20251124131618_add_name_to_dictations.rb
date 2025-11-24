class AddNameToDictations < ActiveRecord::Migration[8.1]
  def change
    add_column :dictations, :name, :string
    # Set default name for existing records
    reversible do |dir|
      dir.up do
        execute "UPDATE dictations SET name = 'Dictée ' || id WHERE name IS NULL"
      end
    end
    change_column_null :dictations, :name, false
  end
end

class AddPluralityAndTenseToWordGroup < ActiveRecord::Migration
  def change
    add_column :word_groups, :plurality, :string
    add_column :word_groups, :tense, :string
  end
end

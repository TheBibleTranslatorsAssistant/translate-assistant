class AddConceptToWordGroup < ActiveRecord::Migration
  def change
    add_column      :word_groups, :concept_id, :integer
    add_index       :word_groups, :concept_id
    add_foreign_key :word_groups, :concepts
    remove_column   :words, :concept_id, :integer
  end
end

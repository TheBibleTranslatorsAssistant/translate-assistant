class AddWordGroupGroupType < ActiveRecord::Migration

  def change
    add_column :word_groups, :group_type, :string
  end

end


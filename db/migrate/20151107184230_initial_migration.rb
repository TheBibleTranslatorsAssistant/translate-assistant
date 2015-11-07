class InitialMigration < ActiveRecord::Migration

  def change
    create_table :concepts do |t|
      t.integer :concept_type, null: false
      t.string  :title,        null: false
      t.string  :description,  null: false

      t.index [ :concept_type, :title, :description ], unique: true
    end

    create_table :words do |t|
      t.string  :word,       null: false
      t.column  :word_index, :serial, null: false
      t.references :concept

      t.index :concept_id
      t.foreign_key :concepts
      t.index :word_index, unique: true
    end

    create_table :sections do |t|
      t.string     :title, null: false
      t.references :word, null: false

      t.index :word_id
      t.foreign_key :words
      t.index :title, unique: true
    end

    create_table :word_groups do |t|
      t.integer :starting_word_id, null: false
      t.integer :ending_word_id,   null: false

      t.index :starting_word_id
      t.index :ending_word_id
      t.index [:starting_word_id, :ending_word_id], unique: true
    end
    add_foreign_key :word_groups, :words, column: :starting_word_id, name: :fk_word_groups_words_start
    add_foreign_key :word_groups, :words, column: :ending_word_id,   name: :fk_word_groups_words_end
  end

end


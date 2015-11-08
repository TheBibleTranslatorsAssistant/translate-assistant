class WordGroup < ActiveRecord::Base

  belongs_to :starting_word, class_name: Word
  belongs_to :ending_word,   class_name: Word

  validates :starting_word, presence: true
  validates :ending_word,   presence: true
  validates :group_type, inclusion: { in: [
    'Sentence',
    'Noun phrase',
    'Verb phrase',
    'Not sure',
  ] }, allow_nil: true

end


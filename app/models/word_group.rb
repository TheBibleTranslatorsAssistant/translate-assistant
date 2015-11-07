class WordGroup < ActiveRecord::Base

  belongs_to :starting_word
  belongs_to :ending_word

  validates :starting_word, presence: true
  validates :ending_word,   presence: true

end


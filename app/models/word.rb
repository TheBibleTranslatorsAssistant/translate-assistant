class Word < ActiveRecord::Base

  belongs_to :concept

  validates :word, presence: true

end


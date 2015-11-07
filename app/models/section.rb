class Section < ActiveRecord::Base

  belongs_to :word

  validates :word, presence: true
  validates :title, presence: true, uniqueness: true

end


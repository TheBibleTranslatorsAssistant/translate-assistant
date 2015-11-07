class Concept < ActiveRecord::Base

  validates :title, presence: true, uniqueness: {
    scope: [ :description, :concept_type ],
    message: 'A concept matching title, description, and concept type already exists.'
  }
  validates :concept_type, presence: true

  enum concept_type: [
    :noun,
    :verb,
    :adjective,
    :adposition,
    :adverb,
    :conjunction,
  ]

  def self.from_hash(hash)
    symbolized_hash = hash.symbolize_keys
    Concept.new({
      id:           symbolized_hash[:id],
      title:        symbolized_hash[:name],
      description:  symbolized_hash[:description],
      concept_type: Concept.concept_types[symbolized_hash[:type].to_sym],
    })
  end

end


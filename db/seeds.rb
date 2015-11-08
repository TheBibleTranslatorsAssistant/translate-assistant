# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [
  'ardell@gmail.com',
  'sackman.nicholas@gmail.com',
].map do |email|
  {
    email: email,
    password: '12345678',
  }
end
User.create(users)

# Load the concepts json file
concepts = JSON.parse IO.read(Rails.root.join('db/seeds/concepts.json'))
concepts.each do |concept_hash|
  concept = Concept.from_hash(concept_hash)
  if concept.valid?
    concept.save!
  else
    puts "Got errors for concept #{concept.inspect}..."
    concept.errors.full_messages.each do |m|
      puts " - #{m}"
    end
  end
end

# Load sections and words
sections = JSON.parse IO.read(Rails.root.join('db/seeds/ruth1.json'))
sections.each do |section_hash|
  word_hashes = section_hash["constituents"].map {|word| { word: word } }
  words       = Word.create!(word_hashes)
  section     = Section.create({
    word: words.first,
    title: section_hash["reference"],
  })
  unless section.valid?
    puts "Got errors for section #{section.inspect}..."
    section.errors.full_messages.each do |m|
      puts " - #{m}"
    end
  end
end

# Create some sample word groups
[
  # start word_index      end word_index
  [ 1,                    7               ],
  [ 1,                    4               ],
  [ 5,                    7               ],
  [ 8,                    10              ],
  [ 8,                    12              ],
  [ 13,                   22              ],
  [ 13,                   16              ],
  [ 17,                   22              ],
  [ 17,                   19              ],
].each do |start_and_end|
  start_word_index, end_word_index = start_and_end
  start_word = Word.find_by_word_index(start_word_index)
  end_word   = Word.find_by_word_index(end_word_index)
  word_group = WordGroup.create(starting_word: start_word, ending_word: end_word)
  unless word_group.valid?
    puts "Got errors for word_group #{word_group.inspect}..."
    word_group.errors.full_messages.each do |m|
      puts " - #{m}"
    end
  end
end


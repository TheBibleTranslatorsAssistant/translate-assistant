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
all_words = Word.order('word_index ASC')
[
  # start word_index      end word_index
  [ 0,                    5               ],
  [ 0,                    2               ],
  [ 3,                    5               ],
  [ 6,                    8               ],
  [ 6,                    10              ],
  [ 11,                   20              ],
  [ 11,                   14              ],
  [ 15,                   20              ],
  [ 15,                   17              ],
  [ 18,                   20              ],
].each do |start_and_end|
  start_word_index, end_word_index = start_and_end
  start_word = all_words[start_word_index]
  end_word   = all_words[end_word_index]
  word_group = WordGroup.create(starting_word: start_word, ending_word: end_word)
  unless word_group.valid?
    puts "Got errors for word_group #{word_group.inspect}..."
    word_group.errors.full_messages.each do |m|
      puts " - #{m}"
    end
  end
end


class AddFullTextSearchIndexes < ActiveRecord::Migration

  def up
    execute <<-sql
CREATE INDEX idx_gin_concepts_title ON concepts USING GIN(TO_TSVECTOR('english', title));
CREATE INDEX idx_gin_concepts_description ON concepts USING GIN(TO_TSVECTOR('english', description));
sql
  end

  def down
    execute <<-sql
DROP INDEX idx_gin_concepts_title;
DROP INDEX idx_gin_concepts_description;
sql
  end

end


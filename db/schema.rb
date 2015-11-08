# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151108172732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "concepts", force: :cascade do |t|
    t.integer "concept_type", null: false
    t.string  "title",        null: false
    t.string  "description",  null: false
  end

  add_index "concepts", ["concept_type", "title", "description"], name: "index_concepts_on_concept_type_and_title_and_description", unique: true, using: :btree

  create_table "sections", force: :cascade do |t|
    t.string  "title",   null: false
    t.integer "word_id", null: false
  end

  add_index "sections", ["title"], name: "index_sections_on_title", unique: true, using: :btree
  add_index "sections", ["word_id"], name: "index_sections_on_word_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "word_groups", force: :cascade do |t|
    t.integer "starting_word_id", null: false
    t.integer "ending_word_id",   null: false
    t.string  "group_type"
    t.integer "concept_id"
  end

  add_index "word_groups", ["concept_id"], name: "index_word_groups_on_concept_id", using: :btree
  add_index "word_groups", ["ending_word_id"], name: "index_word_groups_on_ending_word_id", using: :btree
  add_index "word_groups", ["starting_word_id", "ending_word_id"], name: "index_word_groups_on_starting_word_id_and_ending_word_id", unique: true, using: :btree
  add_index "word_groups", ["starting_word_id"], name: "index_word_groups_on_starting_word_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.string  "word",                                                             null: false
    t.integer "word_index", default: "nextval('words_word_index_seq'::regclass)", null: false
  end

  add_index "words", ["word_index"], name: "index_words_on_word_index", unique: true, using: :btree

  add_foreign_key "sections", "words"
  add_foreign_key "word_groups", "concepts"
  add_foreign_key "word_groups", "words", column: "ending_word_id", name: "fk_word_groups_words_end"
  add_foreign_key "word_groups", "words", column: "starting_word_id", name: "fk_word_groups_words_start"
end

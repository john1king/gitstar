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

ActiveRecord::Schema.define(version: 20150315145629) do

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "readmes", force: :cascade do |t|
    t.integer "repo_id",    limit: 4,                        null: false
    t.text    "content",    limit: 16777215
    t.boolean "is_loading", limit: 1,        default: false
  end

  add_index "readmes", ["repo_id"], name: "index_readmes_on_repo_id", unique: true, using: :btree

  create_table "repos", force: :cascade do |t|
    t.string   "description",             limit: 1000
    t.string   "full_name",               limit: 255
    t.string   "html_url",                limit: 255
    t.string   "language",                limit: 255
    t.integer  "forks_count",             limit: 4
    t.integer  "origin_stargazers_count", limit: 4
    t.datetime "origin_created_at"
    t.datetime "origin_updated_at"
    t.integer  "stargazers_count",        limit: 4,    default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "stars", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "repo_id",      limit: 4
    t.datetime "starred_at"
    t.datetime "last_updated"
    t.string   "description",  limit: 1000, default: "",   null: false
    t.boolean  "active",       limit: 1,    default: true
  end

  add_index "stars", ["starred_at"], name: "index_stars_on_starred_at", using: :btree
  add_index "stars", ["user_id", "repo_id"], name: "index_stars_on_user_id_and_repo_id", unique: true, using: :btree

  create_table "stars_tags", id: false, force: :cascade do |t|
    t.integer "tag_id",  limit: 4, null: false
    t.integer "star_id", limit: 4, null: false
  end

  add_index "stars_tags", ["tag_id", "star_id"], name: "index_stars_tags_on_tag_id_and_star_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",        limit: 255
    t.integer "user_id",     limit: 4
    t.integer "stars_count", limit: 4,   default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "email",       limit: 255
    t.string   "avatar_url",  limit: 255
    t.integer  "stars_count", limit: 4,   default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end

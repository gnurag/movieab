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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2147483647) do

  create_table "acts_as_xapian_jobs", :force => true do |t|
    t.string  "model",    :null => false
    t.integer "model_id", :null => false
    t.string  "action",   :null => false
  end

  add_index "acts_as_xapian_jobs", ["model", "model_id"], :name => "index_acts_as_xapian_jobs_on_model_and_model_id", :unique => true

  create_table "amazon_editorial_reviews", :force => true do |t|
    t.integer  "title_id",                                    :null => false
    t.string   "source",     :limit => 64
    t.text     "content"
    t.boolean  "supressed"
    t.boolean  "disabled",                 :default => false, :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "amazon_images", :force => true do |t|
    t.integer   "title_id",                        :null => false
    t.string    "swatch",           :limit => 100
    t.integer   "swatch_height",    :limit => 2
    t.integer   "swatch_width",     :limit => 2
    t.string    "small",            :limit => 100
    t.integer   "small_height",     :limit => 2
    t.integer   "small_width",      :limit => 2
    t.string    "thumbnail",        :limit => 100
    t.integer   "thumbnail_height", :limit => 2
    t.integer   "thumbnail_width",  :limit => 2
    t.string    "tiny",             :limit => 100
    t.integer   "tiny_height",      :limit => 2
    t.integer   "tiny_width",       :limit => 2
    t.string    "medium",           :limit => 100
    t.integer   "medium_height",    :limit => 2
    t.integer   "medium_width",     :limit => 2
    t.string    "large",            :limit => 100
    t.integer   "large_height",     :limit => 2
    t.integer   "large_width",      :limit => 2
    t.timestamp "created_at",                      :null => false
    t.datetime  "updated_at",                      :null => false
  end

  create_table "amazon_items", :force => true do |t|
    t.integer   "title_id",                       :null => false
    t.string    "asin",            :limit => 20
    t.string    "ean",             :limit => 20
    t.string    "isbn",            :limit => 20
    t.string    "upc",             :limit => 15
    t.text      "detail_page"
    t.integer   "sales_rank"
    t.string    "aspect_ratio",    :limit => 12
    t.string    "audience_rating", :limit => 32
    t.string    "binding",         :limit => 12
    t.integer   "dvd_layers",      :limit => 1
    t.integer   "dvd_sides",       :limit => 1
    t.string    "label",           :limit => 32
    t.string    "manufacturer",    :limit => 32
    t.date      "orig_release"
    t.date      "release_date"
    t.date      "theatre_release"
    t.string    "picture_format",  :limit => 20
    t.string    "publisher",       :limit => 32
    t.integer   "region_code",     :limit => 1
    t.integer   "running_time",    :limit => 2
    t.string    "studio",          :limit => 32
    t.string    "title_name",      :limit => 128
    t.boolean   "deleted"
    t.timestamp "created_at",                     :null => false
    t.datetime  "updated_at",                     :null => false
  end

  add_index "amazon_items", ["asin"], :name => "asin"
  add_index "amazon_items", ["title_id"], :name => "title_id"
  add_index "amazon_items", ["upc"], :name => "upc"

  create_table "award_nominations", :force => true do |t|
    t.integer   "title_id",                                     :null => false
    t.integer   "award_id",   :limit => 2,                      :null => false
    t.integer   "person_id"
    t.integer   "year",       :limit => 2
    t.string    "label",      :limit => 256,                    :null => false
    t.string    "term",       :limit => 256,                    :null => false
    t.string    "award_type", :limit => 20,                     :null => false
    t.boolean   "disabled",                  :default => false
    t.timestamp "created_at",                                   :null => false
    t.datetime  "updated_at",                                   :null => false
  end

  add_index "award_nominations", ["award_type"], :name => "award_type"
  add_index "award_nominations", ["created_at"], :name => "created_at"
  add_index "award_nominations", ["disabled"], :name => "disabled"
  add_index "award_nominations", ["label"], :name => "label"
  add_index "award_nominations", ["term"], :name => "term"
  add_index "award_nominations", ["title_id"], :name => "movie_id"
  add_index "award_nominations", ["year"], :name => "year"

  create_table "awards", :force => true do |t|
    t.string    "scheme",      :limit => 256,                    :null => false
    t.string    "name",        :limit => 100
    t.text      "description"
    t.boolean   "disabled",                   :default => false
    t.timestamp "created_at",                                    :null => false
    t.datetime  "updated_at",                                    :null => false
  end

  add_index "awards", ["created_at"], :name => "created_at"
  add_index "awards", ["disabled"], :name => "disabled"
  add_index "awards", ["name"], :name => "name"
  add_index "awards", ["scheme"], :name => "scheme", :unique => true

  create_table "freebase_facts", :force => true do |t|
    t.integer   "title_id",                                               :null => false
    t.string    "freebase_id",          :limit => 42,                     :null => false
    t.date      "initial_release_date"
    t.string    "music",                :limit => 100
    t.string    "language",             :limit => 20
    t.integer   "rating",               :limit => 1
    t.integer   "estimated_budget"
    t.string    "country",              :limit => 20
    t.integer   "runtime",              :limit => 2
    t.integer   "film_collections"
    t.string    "soundtrack",           :limit => 300
    t.string    "genre",                :limit => 42
    t.string    "film_format",          :limit => 42
    t.string    "tagline",              :limit => 100
    t.boolean   "disabled",                            :default => false, :null => false
    t.timestamp "created_at",                                             :null => false
    t.datetime  "updated_at",                                             :null => false
  end

  add_index "freebase_facts", ["freebase_id"], :name => "freebase_id"

  create_table "generes", :force => true do |t|
    t.string    "name",        :limit => 128,                    :null => false
    t.string    "genere_type", :limit => 32
    t.boolean   "disabled",                   :default => false
    t.timestamp "created_at",                                    :null => false
    t.datetime  "updated_at",                                    :null => false
  end

  add_index "generes", ["genere_type"], :name => "genere_type"
  add_index "generes", ["name"], :name => "name"

  create_table "google_images", :force => true do |t|
    t.string    "resource_type",         :limit => 10,                     :null => false
    t.integer   "resource_id",                                             :null => false
    t.string    "gsearch_result_class",  :limit => 20
    t.string    "title",                 :limit => 100
    t.string    "title_no_formatting",   :limit => 100
    t.string    "content",               :limit => 100
    t.string    "content_no_formatting", :limit => 100
    t.string    "image_id",              :limit => 32
    t.integer   "width",                 :limit => 3
    t.integer   "height",                :limit => 3
    t.integer   "tb_width",              :limit => 2
    t.integer   "tb_height",             :limit => 2
    t.string    "unescaped_url",         :limit => 300,                    :null => false
    t.string    "visible_url",           :limit => 300,                    :null => false
    t.string    "url",                   :limit => 300,                    :null => false
    t.string    "tb_url",                :limit => 300,                    :null => false
    t.string    "original_context_url",  :limit => 300
    t.boolean   "disabled",                             :default => false
    t.timestamp "created_at",                                              :null => false
    t.datetime  "updated_at"
  end

  add_index "google_images", ["created_at"], :name => "created_at"
  add_index "google_images", ["disabled"], :name => "disabled"
  add_index "google_images", ["resource_type", "resource_id"], :name => "resource_type"

  create_table "nytimes_reviews", :force => true do |t|
    t.integer   "title_id",                                           :null => false
    t.string    "nyt_movie_id",     :limit => 24,                     :null => false
    t.string    "display_title",    :limit => 256,                    :null => false
    t.string    "sort_name",        :limit => 256
    t.string    "mpaa_rating",      :limit => 6
    t.boolean   "critics_pick",                    :default => false
    t.boolean   "thousand_best",                   :default => false
    t.string    "byline",           :limit => 100
    t.text      "headline"
    t.text      "capsule_review"
    t.text      "summary_short"
    t.date      "publication_date"
    t.date      "opening_date"
    t.date      "dvd_release_date"
    t.datetime  "date_updated"
    t.string    "seo_name",         :limit => 256
    t.string    "article_url",      :limit => 256
    t.string    "overview_url",     :limit => 256
    t.string    "showtimes_url",    :limit => 256
    t.string    "awards_url",       :limit => 256
    t.string    "community_url",    :limit => 256
    t.string    "trailers_url",     :limit => 256
    t.string    "thumbnail",        :limit => 256
    t.boolean   "nyt_synced",                      :default => false
    t.timestamp "created_at",                                         :null => false
    t.datetime  "updated_at",                                         :null => false
  end

  add_index "nytimes_reviews", ["display_title"], :name => "display_title"
  add_index "nytimes_reviews", ["nyt_movie_id"], :name => "nyt_movie_id"
  add_index "nytimes_reviews", ["title_id"], :name => "title_id"

  create_table "people", :force => true do |t|
    t.string    "netflix_id",  :limit => 120,                    :null => false
    t.integer   "nfid",                                          :null => false
    t.string    "name",        :limit => 100,                    :null => false
    t.string    "role",        :limit => 32,                     :null => false
    t.text      "bio"
    t.string    "website_url", :limit => 256
    t.boolean   "nf_synced"
    t.boolean   "gi_synced",                  :default => false
    t.boolean   "disabled",                   :default => false, :null => false
    t.timestamp "created_at",                                    :null => false
    t.datetime  "updated_at",                                    :null => false
  end

  add_index "people", ["bio"], :name => "bio"
  add_index "people", ["disabled"], :name => "disabled"
  add_index "people", ["name"], :name => "name"
  add_index "people", ["netflix_id"], :name => "netflix_id"
  add_index "people", ["nfid"], :name => "nfid"
  add_index "people", ["role"], :name => "type"

  create_table "reviews", :force => true do |t|
    t.string    "resource_type", :limit => 16,                     :null => false
    t.integer   "resource_id",                                     :null => false
    t.string    "title",         :limit => 128
    t.text      "review"
    t.integer   "slno",          :limit => 3
    t.boolean   "published",                    :default => true
    t.boolean   "disabled",                     :default => false
    t.integer   "reviewed_by",                                     :null => false
    t.timestamp "created_at",                                      :null => false
    t.datetime  "updated_at"
  end

  add_index "reviews", ["disabled"], :name => "disabled"
  add_index "reviews", ["published"], :name => "published"
  add_index "reviews", ["resource_type", "resource_id"], :name => "resource_type"
  add_index "reviews", ["slno"], :name => "slno"

  create_table "roles", :force => true do |t|
    t.string    "name",        :limit => 64,                     :null => false
    t.string    "description", :limit => 256
    t.boolean   "disabled",                   :default => false
    t.timestamp "created_at",                                    :null => false
    t.datetime  "updated_at"
  end

  add_index "roles", ["name"], :name => "name"

  create_table "title_casts", :force => true do |t|
    t.integer   "person_id",                     :null => false
    t.integer   "title_id",                      :null => false
    t.boolean   "disabled",   :default => false
    t.timestamp "created_at",                    :null => false
    t.datetime  "updated_at",                    :null => false
  end

  add_index "title_casts", ["disabled"], :name => "disabled"
  add_index "title_casts", ["person_id"], :name => "person_id"
  add_index "title_casts", ["title_id"], :name => "title_id"

  create_table "title_generes", :force => true do |t|
    t.integer   "title_id",                      :null => false
    t.integer   "genere_id",                     :null => false
    t.boolean   "disabled",   :default => false
    t.timestamp "created_at",                    :null => false
    t.datetime  "updated_at",                    :null => false
  end

  add_index "title_generes", ["genere_id"], :name => "genere_id"
  add_index "title_generes", ["title_id"], :name => "title_id"

  create_table "title_upc", :force => true do |t|
    t.integer   "title_id",                 :null => false
    t.string    "upc",        :limit => 15, :null => false
    t.timestamp "created_at",               :null => false
    t.datetime  "updated_at",               :null => false
  end

  add_index "title_upc", ["title_id"], :name => "title_id"
  add_index "title_upc", ["upc"], :name => "upc"

  create_table "titles", :force => true do |t|
    t.string    "netflix_id",            :limit => 120,                      :null => false
    t.integer   "nfid",                                                      :null => false
    t.string    "title_type",            :limit => 20,  :default => "movie"
    t.string    "title",                 :limit => 256,                      :null => false
    t.string    "title_short",           :limit => 256
    t.text      "synopsis"
    t.integer   "release_year",          :limit => 2
    t.integer   "runtime",               :limit => 3
    t.string    "mpaa_rating",           :limit => 6
    t.float     "netflix_rating"
    t.string    "main_genere",           :limit => 42
    t.string    "website_url",           :limit => 256
    t.string    "alternate_website_url", :limit => 256
    t.integer   "supplier_id",           :limit => 2,                        :null => false
    t.integer   "creator_id",            :limit => 2
    t.string    "box_art_small",         :limit => 392
    t.string    "box_art_medium",        :limit => 392
    t.string    "box_art_large",         :limit => 392
    t.datetime  "nf_created"
    t.datetime  "nf_updated"
    t.datetime  "nf_published"
    t.integer   "title_format_id",       :limit => 1
    t.integer   "audio_format_id",       :limit => 1
    t.integer   "language_id",           :limit => 1
    t.boolean   "nf_synced",                            :default => false
    t.boolean   "nyt_synced",                           :default => false
    t.boolean   "gi_synced",                            :default => false
    t.boolean   "gv_synced",                            :default => false
    t.boolean   "amzn_synced",                          :default => false,   :null => false
    t.boolean   "disabled",                                                  :null => false
    t.timestamp "created_at",                                                :null => false
    t.datetime  "updated_at",                                                :null => false
  end

  add_index "titles", ["created_at"], :name => "created_at"
  add_index "titles", ["disabled"], :name => "disabled"
  add_index "titles", ["language_id"], :name => "language_id"
  add_index "titles", ["main_genere"], :name => "main_genere"
  add_index "titles", ["mpaa_rating"], :name => "mpaa_rating"
  add_index "titles", ["netflix_id"], :name => "netflix_id"
  add_index "titles", ["netflix_rating"], :name => "netflix_rating"
  add_index "titles", ["nf_created"], :name => "nf_created"
  add_index "titles", ["nf_updated"], :name => "nf_updated"
  add_index "titles", ["nfid"], :name => "nfid"
  add_index "titles", ["release_year"], :name => "release_year"
  add_index "titles", ["synopsis"], :name => "synopsis"
  add_index "titles", ["title"], :name => "title"
  add_index "titles", ["title"], :name => "title_2"
  add_index "titles", ["updated_at"], :name => "updated_at"

  create_table "user_roles", :force => true do |t|
    t.integer   "user_id",                       :null => false
    t.integer   "role_id",                       :null => false
    t.boolean   "disabled",   :default => false
    t.timestamp "created_at",                    :null => false
    t.datetime  "updated_at"
  end

  add_index "user_roles", ["user_id", "role_id"], :name => "user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

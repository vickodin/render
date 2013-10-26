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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131025044918) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "answers", :force => true do |t|
    t.integer  "submit_id"
    t.integer  "field_id"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "answers", ["field_id"], :name => "index_answers_on_field_id"
  add_index "answers", ["submit_id"], :name => "index_answers_on_submit_id"

  create_table "cachers", :force => true do |t|
    t.text     "content"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "cacheable_type", :default => "Page", :null => false
    t.integer  "cacheable_id"
  end

  add_index "cachers", ["cacheable_type", "cacheable_id"], :name => "index_cachers_on_cacheable_type_and_cacheable_id"

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fields", :force => true do |t|
    t.integer  "form_id"
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "kind"
  end

  add_index "fields", ["form_id"], :name => "index_fields_on_form_id"

  create_table "forms", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "uuid",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "redirect"
  end

  add_index "forms", ["user_id"], :name => "index_forms_on_user_id"
  add_index "forms", ["uuid"], :name => "index_forms_on_uuid"

  create_table "forms_sites", :id => false, :force => true do |t|
    t.integer "form_id"
    t.integer "site_id"
  end

  add_index "forms_sites", ["form_id", "site_id"], :name => "index_forms_sites_on_form_id_and_site_id", :unique => true

  create_table "images", :force => true do |t|
    t.string   "name"
    t.string   "photo"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "images", ["site_id"], :name => "index_images_on_site_id"

  create_table "javascripts", :force => true do |t|
    t.text     "content"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "site_id"
    t.string   "name",       :default => "", :null => false
  end

  add_index "javascripts", ["site_id", "name"], :name => "index_javascripts_on_site_id_and_name", :unique => true
  add_index "javascripts", ["site_id"], :name => "index_javascripts_on_site_id"

  create_table "layouts", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.text     "content"
    t.integer  "site_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "layouts", ["site_id", "name"], :name => "index_layouts_on_site_id_and_name", :unique => true
  add_index "layouts", ["site_id"], :name => "index_layouts_on_site_id"

  create_table "news", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.text     "preview"
  end

  add_index "news", ["slug"], :name => "index_news_on_slug"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "site_id"
    t.text     "content"
    t.boolean  "system",     :default => false,  :null => false
    t.string   "kind",       :default => "html", :null => false
  end

  add_index "pages", ["site_id", "kind", "name"], :name => "index_pages_on_site_id_and_kind_and_name", :unique => true
  add_index "pages", ["site_id"], :name => "index_pages_on_site_id"

  create_table "reviews", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.string   "photo"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "domain_id"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "own_domain",  :default => "",                    :null => false
    t.text     "more"
    t.boolean  "compress",    :default => true
    t.datetime "modified_at", :default => '2013-10-19 06:44:24', :null => false
    t.boolean  "public",      :default => false,                 :null => false
  end

  add_index "sites", ["domain_id"], :name => "index_sites_on_domain_id"
  add_index "sites", ["own_domain"], :name => "index_sites_on_own_domain"
  add_index "sites", ["user_id"], :name => "index_sites_on_user_id"

  create_table "stylesheets", :force => true do |t|
    t.text     "content"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "site_id"
    t.string   "name",       :default => "", :null => false
  end

  add_index "stylesheets", ["site_id", "name"], :name => "index_stylesheets_on_site_id_and_name", :unique => true
  add_index "stylesheets", ["site_id"], :name => "index_stylesheets_on_site_id"

  create_table "submits", :force => true do |t|
    t.integer  "form_id"
    t.string   "ip"
    t.string   "ua"
    t.string   "referer"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "submits", ["form_id"], :name => "index_submits_on_form_id"

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "site_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "templates", ["site_id", "name"], :name => "index_templates_on_site_id_and_name", :unique => true
  add_index "templates", ["site_id"], :name => "index_templates_on_site_id"

  create_table "traffics", :force => true do |t|
    t.integer  "site_id"
    t.integer  "hosts"
    t.integer  "hits"
    t.integer  "visitors"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "traffics", ["site_id"], :name => "index_traffics_on_site_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

end

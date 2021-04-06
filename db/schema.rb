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

ActiveRecord::Schema.define(version: 2021_04_06_101722) do

  create_table "addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "address_code"
    t.string "desc"
    t.integer "user_id"
    t.string "phone"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "address_type", default: 0
    t.boolean "default", default: false
  end

  create_table "admin_commission_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "admin_commission_id"
    t.integer "order_id"
    t.integer "admin_id"
    t.integer "commission"
    t.integer "commission_before", default: 0
    t.integer "commission_after", default: 0
    t.text "desc"
    t.integer "commission_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_commissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "commission", default: 0
    t.integer "commission_wait", default: 0
    t.integer "commission_paid", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "phone"
    t.string "role_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "login"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_admins_on_deleted_at"
    t.index ["phone"], name: "index_admins_on_phone"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type"
    t.string "file_path"
    t.string "file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.integer "priority", default: 1
    t.integer "product_id"
    t.integer "attachment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_num", default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
  end

  create_table "commission_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "user_id"
    t.integer "amount"
    t.string "status"
    t.string "commission_type"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "user_name"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_companies_on_deleted_at"
  end

  create_table "model_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "model_id"
    t.integer "attachment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "content"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "norms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.integer "price"
    t.string "name"
    t.integer "stock"
    t.integer "sale", default: 0
    t.string "spec_attrs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_norms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "norm_id"
    t.integer "product_id"
    t.integer "order_id"
    t.integer "number"
    t.integer "price"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "no"
    t.integer "amount"
    t.string "status"
    t.integer "user_id"
    t.datetime "payment_at"
    t.integer "address_id"
    t.text "desc"
    t.integer "admin_id"
    t.datetime "server_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "share_user_id"
    t.integer "commission", default: 0
    t.integer "commission_log_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
  end

  create_table "payment_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "payment_id"
    t.text "apply_res"
    t.string "prepay_id"
    t.text "response_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_id"
    t.integer "user_id"
    t.string "type"
    t.string "status"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "apply_res"
    t.string "prepay_id"
    t.text "response_data"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "category_id"
    t.string "product_type"
    t.string "name"
    t.string "status", default: "off"
    t.integer "sale", default: 0
    t.integer "commission"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "no"
    t.integer "amount", default: 0
    t.integer "main_attachment_id"
    t.integer "high_commission"
    t.datetime "deleted_at"
    t.integer "admin_commission", default: 0
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "target"
    t.string "action"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "role_resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "role_id"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tag"
  end

  create_table "spec_values", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "spec_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "product_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_commission_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_commission_id"
    t.integer "order_id"
    t.integer "user_id"
    t.integer "commission"
    t.integer "commission_before", default: 0
    t.integer "commission_after", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "commission_type"
  end

  create_table "user_commissions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "share_order", default: 0
    t.integer "commission", default: 0
    t.integer "commission_wait", default: 0
    t.integer "commission_paid", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "authentication_token"
    t.string "code"
    t.integer "gender"
    t.string "nick_name"
    t.string "country"
    t.string "province"
    t.string "city"
    t.string "avatar_url"
    t.string "open_id"
    t.string "delete_at"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "last_active_at"
    t.integer "admin_id"
    t.string "share_token"
    t.integer "company_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

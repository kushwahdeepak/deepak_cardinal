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

ActiveRecord::Schema.define(version: 2020_05_11_012218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "academic_honors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.datetime "createdonsystem"
    t.string "crelate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_academic_honors_on_crelate_id"
  end

  create_table "account_managers", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "account_sources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "createdonsystem"
    t.string "crelate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_account_sources_on_crelate_id"
  end

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "name"
    t.datetime "modifiedon"
    t.datetime "createdon"
    t.string "updatedbyid"
    t.string "createdbyid"
    t.string "department"
    t.string "iconattachmentid"
    t.string "primarydocumentattachmentid"
    t.string "description"
    t.string "statusid"
    t.string "parentaccountid"
    t.string "formdefinitionid"
    t.string "recordtype"
    t.datetime "createdonsystem"
    t.string "customfield1"
    t.string "customfield2"
    t.string "customfield3"
    t.string "customfield4"
    t.string "customfield5"
    t.string "customfield6"
    t.string "customfield7"
    t.string "customfield8"
    t.string "customfield9"
    t.string "customfield10"
    t.string "accountsourceid"
    t.string "accountsourceid_type"
    t.string "estimatedrevenue"
    t.string "ebitda"
    t.string "revenue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recruiter_update_id"
    t.integer "user_id"
    t.index ["crelate_id"], name: "index_accounts_on_crelate_id"
    t.index ["recruiter_update_id"], name: "index_accounts_on_recruiter_update_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "accreditations", id: :serial, force: :cascade do |t|
    t.string "value"
    t.datetime "createdonsystem"
    t.string "crelate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_accreditations_on_crelate_id"
  end

  create_table "accrediting_institutions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "createdonsystem"
    t.string "crelate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_accrediting_institutions_on_crelate_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "acts_as_bookable_bookings", id: :serial, force: :cascade do |t|
    t.string "bookable_type"
    t.integer "bookable_id"
    t.string "booker_type"
    t.integer "booker_id"
    t.integer "amount"
    t.text "schedule"
    t.datetime "time_start"
    t.datetime "time_end"
    t.datetime "time"
    t.datetime "created_at"
    t.index ["bookable_type", "bookable_id"], name: "index_acts_as_bookable_bookings_bookable"
    t.index ["booker_type", "booker_id"], name: "index_acts_as_bookable_bookings_booker"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "categorytypeid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "location"
    t.boolean "isprimary"
    t.string "countryid"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.index ["crelate_id"], name: "index_addresses_on_crelate_id"
    t.index ["person_id"], name: "index_addresses_on_person_id"
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_answers_on_person_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "applications", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "name"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "primarydocumentattachmentid"
    t.string "firstname"
    t.string "lastname"
    t.string "parsedfirstname"
    t.string "parsedlastname"
    t.string "parsedemail"
    t.string "parsedcity"
    t.string "parsedstate"
    t.string "parsedzip"
    t.string "statusid"
    t.string "contactid"
    t.string "parsedphone"
    t.string "workflowid"
    t.string "contactsourceid"
    t.string "formid"
    t.string "middlename"
    t.datetime "createdonsystem"
    t.string "jobtitle"
    t.string "currentcompanyid"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jobid"
    t.index ["crelate_id"], name: "index_applications_on_crelate_id"
  end

  create_table "archive_states", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.string "lever_id"
    t.datetime "archived_at"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lever_id"], name: "index_archive_states_on_lever_id"
    t.index ["person_id"], name: "index_archive_states_on_person_id"
  end

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.string "Attachment"
    t.string "crelate_id"
    t.string "filename"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "entitytypeid"
    t.string "contenttype"
    t.integer "contentlength"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.boolean "isimage"
    t.boolean "isdocument"
    t.string "attachmenttypeid"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "statuscode"
    t.index ["crelate_id"], name: "index_attachments_on_crelate_id"
  end

  create_table "avatars", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "call_sheets", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "num_calls"
    t.integer "person_id"
    t.integer "num_submittals"
    t.integer "num_phone_interviews"
    t.integer "num_onsite_interviews"
    t.integer "num_placements"
    t.integer "num_inmails"
    t.datetime "client_update_email_sent_at"
    t.string "call_sheet_upload_file_name"
    t.string "call_sheet_upload_content_type"
    t.integer "call_sheet_upload_file_size"
    t.datetime "call_sheet_upload_updated_at"
    t.string "status"
    t.text "notes"
    t.date "date"
    t.string "name"
    t.string "role"
    t.string "client"
    t.string "lead_source"
    t.string "email"
    t.string "phone_number"
    t.string "visa"
    t.string "company"
    t.string "university"
    t.string "linkedin_url"
    t.index ["person_id"], name: "index_call_sheets_on_person_id"
    t.index ["user_id"], name: "index_call_sheets_on_user_id"
  end

  create_table "calls", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "scheduled_time"
    t.integer "person_id"
    t.integer "call_sheet_id"
    t.string "first_name"
    t.string "last_name"
    t.index ["call_sheet_id"], name: "index_calls_on_call_sheet_id"
    t.index ["person_id"], name: "index_calls_on_person_id"
    t.index ["user_id"], name: "index_calls_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_accounts", id: :serial, force: :cascade do |t|
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "user_id"
    t.index ["person_id"], name: "index_comments_on_person_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "company_positions", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.integer "email_address_id"
    t.boolean "is_current"
    t.date "start_date"
    t.integer "start_date_year"
    t.integer "start_date_month"
    t.date "end_date"
    t.integer "end_date_year"
    t.integer "end_date_month"
    t.string "title"
    t.integer "linkedin_profile_position_id"
    t.float "score"
    t.integer "person_id_id"
    t.integer "email_address_id_id"
    t.integer "linkedin_profile_position_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "linkedin_profile_positions_id"
    t.integer "people_id"
    t.integer "user_id"
    t.index ["email_address_id"], name: "index_company_positions_on_email_address_id"
    t.index ["email_address_id_id"], name: "index_company_positions_on_email_address_id_id"
    t.index ["linkedin_profile_position_id"], name: "index_company_positions_on_linkedin_profile_position_id"
    t.index ["linkedin_profile_position_id_id"], name: "index_company_positions_on_linkedin_profile_position_id_id"
    t.index ["person_id"], name: "index_company_positions_on_person_id"
    t.index ["person_id_id"], name: "index_company_positions_on_person_id_id"
    t.index ["user_id"], name: "index_company_positions_on_user_id"
  end

  create_table "contact_sources", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "name"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_contact_sources_on_crelate_id"
  end

  create_table "conversations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "crelate_users", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "fullname"
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.string "userstateid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_crelate_users_on_crelate_id"
  end

  create_table "date_items", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "categorytypeid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.datetime "value"
    t.boolean "isprimary"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_date_items_on_crelate_id"
  end

  create_table "eeo_others", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "value"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_eeo_others_on_crelate_id"
  end

  create_table "email_addresses", id: :serial, force: :cascade do |t|
    t.string "email"
    t.decimal "valid_confidence"
    t.integer "linkedin_profile_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "credible"
    t.integer "linkedin_profile_id"
    t.string "source"
    t.datetime "createdon"
    t.string "categorytypeid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.boolean "isprimary"
    t.string "emailflagtypeid"
    t.string "emailflagerror"
    t.string "crelate_id"
    t.integer "user_id"
    t.integer "person_id"
    t.index ["linkedin_profile_id_id"], name: "index_email_addresses_on_linkedin_profile_id_id"
  end

  create_table "email_lookups", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "attributeid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "rightentityid"
    t.string "rightentityid_type"
    t.string "address"
    t.boolean "isplainaddress"
    t.string "description"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_email_lookups_on_crelate_id"
  end

  create_table "employer_company_profiles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean "visibility"
    t.text "corporate_mission"
    t.string "office_locations"
    t.date "year_founded"
    t.integer "employees_count"
    t.integer "engineers_count"
    t.string "industry_specialization"
    t.string "company_url"
    t.string "crunchbase_url"
    t.string "angellist_url"
    t.text "tech_stack"
    t.text "perks"
    t.text "benefits"
    t.string "name"
    t.index ["user_id"], name: "index_employer_company_profiles_on_user_id"
  end

  create_table "entries", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "experiences", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "verbid"
    t.string "display"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.string "location"
    t.datetime "when"
    t.string "parentid"
    t.string "parentid_type"
    t.string "resultid"
    t.string "regardingid"
    t.string "regardingid_type"
    t.boolean "completed"
    t.datetime "completedon"
    t.string "from"
    t.string "to"
    t.string "cc"
    t.string "attachmentid"
    t.string "allday"
    t.boolean "pinned"
    t.boolean "announced"
    t.string "parentexperienceid"
    t.string "bcc"
    t.string "html"
    t.string "emailflagtypeid"
    t.string "emailflagreason"
    t.string "whenend"
    t.string "emailalternatehtml"
    t.boolean "isinvite"
    t.datetime "createdonsystem"
    t.string "emailrawheader"
    t.string "emailimportance"
    t.string "displaytype"
    t.string "parent2id"
    t.string "parent2id_type"
    t.string "workflowitemid"
    t.string "credentialid"
    t.string "emailstatus"
    t.string "icaluid"
    t.index ["crelate_id"], name: "index_experiences_on_crelate_id"
  end

# Could not dump table "farmers" because of following StandardError
#   Unknown type 'crop_type' for column 'crop'

  create_table "flagged_candidates", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_flagged_candidates_on_person_id"
    t.index ["user_id"], name: "index_flagged_candidates_on_user_id"
  end

  create_table "followed_candidates", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "user_id"
    t.index ["person_id"], name: "index_followed_candidates_on_person_id"
    t.index ["user_id"], name: "index_followed_candidates_on_user_id"
  end

  create_table "follows", id: :serial, force: :cascade do |t|
    t.string "followable_type", null: false
    t.integer "followable_id", null: false
    t.string "follower_type", null: false
    t.integer "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "form_fields", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "value"
    t.string "formfieldtypeid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_form_fields_on_crelate_id"
  end

  create_table "form_responses", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "modifiedon"
    t.datetime "createdon"
    t.string "updatedbyid"
    t.string "createdbyid"
    t.string "formfieldid"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "formid"
    t.string "rating"
    t.datetime "createdonsystem"
    t.index ["crelate_id"], name: "index_form_responses_on_crelate_id"
  end

  create_table "forms", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "formdefinitionid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "url"
    t.boolean "iscomplete"
    t.datetime "createdonsystem"
    t.string "layout"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_forms_on_crelate_id"
  end

  create_table "group_conversations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_conversations_users", id: false, force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "user_id"
    t.index ["conversation_id"], name: "index_group_conversations_users_on_conversation_id"
    t.index ["user_id"], name: "index_group_conversations_users_on_user_id"
  end

  create_table "group_messages", id: :serial, force: :cascade do |t|
    t.string "content"
    t.string "added_new_users"
    t.string "seen_by"
    t.integer "user_id"
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_group_messages_on_conversation_id"
    t.index ["user_id"], name: "index_group_messages_on_user_id"
  end

  create_table "hiring_managers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "instant_addresses", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "value"
    t.boolean "isprimary"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "categorytypeid"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_instant_addresses_on_crelate_id"
  end

  create_table "intake_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "model_klass"
    t.integer "ok_count", default: 0, null: false
    t.integer "err_count", default: 0, null: false
    t.string "code_version"
    t.string "status", default: "not done", null: false
    t.bigint "user_id", null: false
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_intake_batches_on_user_id"
  end

  create_table "interviewees", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interviews", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "content"
    t.integer "price"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "timezone"
    t.string "duration"
    t.date "date"
    t.time "time"
    t.string "format"
    t.string "location"
    t.text "comment"
    t.integer "user_id"
    t.text "schedule"
    t.integer "capacity"
    t.integer "interviewee_id"
    t.index ["interviewee_id"], name: "index_interviews_on_interviewee_id"
    t.index ["user_id"], name: "index_interviews_on_user_id"
  end

  create_table "invited_bies", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "branch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_companies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_locatables", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_location_interests", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_job_location_interests_on_user_id"
  end

  create_table "job_location_interests_users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_locations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "job_locatable_id"
    t.string "job_locatable_type"
    t.string "job_city"
    t.string "job_state"
    t.string "job_country"
    t.index ["job_locatable_id", "job_locatable_type"], name: "index_job_locations_on_job_locatable_id_and_job_locatable_type"
  end

  create_table "job_posts", id: :serial, force: :cascade do |t|
    t.integer "hiring_manager_id"
    t.integer "job_category_id"
    t.integer "job_company_id"
    t.integer "user_id"
    t.boolean "h1b_fulfilment"
    t.boolean "relocation_requested"
    t.boolean "remote_position"
    t.date "start_date"
    t.integer "compensation"
    t.integer "number_open_positions"
    t.string "compensation_type"
    t.string "job_title"
    t.string "job_type"
    t.string "location"
    t.string "website"
    t.string "work_authorization"
    t.text "compensation_details"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hiring_manager_id"], name: "index_job_posts_on_hiring_manager_id"
    t.index ["job_category_id"], name: "index_job_posts_on_job_category_id"
    t.index ["job_company_id"], name: "index_job_posts_on_job_company_id"
    t.index ["user_id"], name: "index_job_posts_on_user_id"
  end

  create_table "job_searches", id: :serial, force: :cascade do |t|
    t.string "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_job_searches_on_user_id"
  end

  create_table "job_titles", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "title"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_job_titles_on_crelate_id"
  end

  create_table "job_types", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "name"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_job_types_on_crelate_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "numberofopenings"
    t.datetime "startdate"
    t.string "description"
    t.string "primarydocumentattachmentid"
    t.string "externalemailaddress"
    t.string "compensation"
    t.string "compensationdetails"
    t.string "portaldescription"
    t.string "portaltitle"
    t.datetime "useropendate"
    t.datetime "userclosedate"
    t.string "portalcompanyname"
    t.integer "portalzip"
    t.string "portalcompensation"
    t.string "portalcity"
    t.string "portalstate"
    t.datetime "portallastpostedon"
    t.datetime "closedon"
    t.boolean "portalvisibility"
    t.string "formdefinitionid"
    t.integer "jobnum"
    t.datetime "createdonsystem"
    t.string "jobcategoryid"
    t.string "portalcountryid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recruiter_update_id"
    t.string "skills"
    t.integer "user_id"
    t.integer "managed_account_id"
    t.string "job_exp"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "pref_skills"
    t.string "gen_reqs"
    t.string "benefits"
    t.string "work_time"
    t.index ["managed_account_id"], name: "index_jobs_on_managed_account_id"
    t.index ["recruiter_update_id"], name: "index_jobs_on_recruiter_update_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "leads", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "device"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepts"
    t.datetime "accepts_date"
  end

  create_table "lever_payload_subscriptions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "linked_accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.integer "expires"
    t.integer "expires_at"
    t.string "refresh_token"
    t.string "display_name"
    t.string "profile_image"
    t.datetime "token_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_linked_accounts_on_user_id"
  end

  create_table "linkedin_field_of_studies", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "linkedin_industries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "linkedin_profile_id"
    t.integer "linkedin_profiles_id"
    t.index ["linkedin_profile_id"], name: "index_linkedin_industries_on_linkedin_profile_id"
    t.index ["linkedin_profiles_id"], name: "index_linkedin_industries_on_linkedin_profiles_id"
  end

  create_table "linkedin_profile_educations", id: :serial, force: :cascade do |t|
    t.integer "linkedin_profile_id"
    t.string "school_name"
    t.string "field_of_study"
    t.string "degree"
    t.date "start_date"
    t.string "start_date_year"
    t.string "start_date_month"
    t.date "end_date"
    t.string "end_date_year"
    t.string "end_date_month"
    t.string "activities"
    t.string "notes"
    t.integer "linkedin_field_of_study_id"
    t.integer "linkedin_school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "user_id"
    t.string "gpa"
    t.index ["linkedin_field_of_study_id"], name: "index_linkedin_profile_educations_on_linkedin_field_of_study_id"
    t.index ["linkedin_profile_id"], name: "index_linkedin_profile_educations_on_linkedin_profile_id"
    t.index ["linkedin_school_id"], name: "index_linkedin_profile_educations_on_linkedin_school_id"
    t.index ["person_id"], name: "index_linkedin_profile_educations_on_person_id"
    t.index ["user_id"], name: "index_linkedin_profile_educations_on_user_id"
  end

  create_table "linkedin_profile_positions", id: :serial, force: :cascade do |t|
    t.string "company_name"
    t.boolean "is_current"
    t.date "start_date"
    t.string "start_date_year"
    t.string "start_date_month"
    t.date "end_date"
    t.string "end_date_year"
    t.string "end_date_month"
    t.string "title"
    t.string "summary"
    t.string "locality"
    t.integer "linkedin_profile_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "user_id"
    t.index ["linkedin_profile_id_id"], name: "index_linkedin_profile_positions_on_linkedin_profile_id_id"
    t.index ["person_id"], name: "index_linkedin_profile_positions_on_person_id"
    t.index ["user_id"], name: "index_linkedin_profile_positions_on_user_id"
  end

  create_table "linkedin_profile_publications", id: :serial, force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.integer "date_year"
    t.integer "date_month"
    t.integer "linkedin_profile_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.index ["linkedin_profile_id_id"], name: "index_linkedin_profile_publications_on_linkedin_profile_id_id"
    t.index ["person_id"], name: "index_linkedin_profile_publications_on_person_id"
  end

  create_table "linkedin_profile_recommendations", id: :serial, force: :cascade do |t|
    t.string "text"
    t.string "type"
    t.integer "recommender_id"
    t.integer "linkedin_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "table_type"
    t.integer "person_id"
    t.index ["linkedin_profile_id"], name: "index_linkedin_profile_recommendations_on_linkedin_profile_id"
    t.index ["person_id"], name: "index_linkedin_profile_recommendations_on_person_id"
    t.index ["recommender_id"], name: "index_linkedin_profile_recommendations_on_recommender_id"
  end

  create_table "linkedin_profile_url_resources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "domain"
    t.integer "linkedin_profile_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "credible"
    t.integer "person_id"
    t.index ["linkedin_profile_id_id"], name: "index_linkedin_profile_url_resources_on_linkedin_profile_id_id"
    t.index ["person_id"], name: "index_linkedin_profile_url_resources_on_person_id"
  end

  create_table "linkedin_profiles", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "headline"
    t.integer "linkedin_industry_id"
    t.string "public_profile_url"
    t.integer "linkedin_industry_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_name"
    t.string "formatted_name"
    t.string "location_name"
    t.string "location_country_code"
    t.string "picture_url"
    t.string "internal_picture_url"
    t.integer "connections"
    t.integer "num_recommenders"
    t.string "skills"
    t.string "following_industries"
    t.string "associations"
    t.string "proposal_comments"
    t.string "summary"
    t.string "interests"
    t.string "internal_picture_url_lg"
    t.string "picture_url_lg"
    t.string "cse_picture_url"
    t.string "cse_picture_url_thumb"
    t.string "internal_cse_picture_url"
    t.string "internal_cse_picture_url_thumb"
    t.string "specialties"
    t.integer "linkedin_profile_id"
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "categorytypeid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "value"
    t.boolean "isprimary"
    t.datetime "createdonsystem"
    t.boolean "credible"
    t.string "linkedin_uid"
    t.boolean "sales_crm_flag"
    t.integer "user_id"
    t.integer "person_id"
    t.index ["linkedin_industry_id_id"], name: "index_linkedin_profiles_on_linkedin_industry_id_id"
    t.index ["linkedin_profile_id"], name: "index_linkedin_profiles_on_linkedin_profile_id"
  end

  create_table "linkedin_schools", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "logo_url"
    t.string "internal_logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "LinkedinProfileEducation_id"
    t.integer "linkedin_profile_education_id"
    t.index ["LinkedinProfileEducation_id"], name: "index_linkedin_schools_on_LinkedinProfileEducation_id"
    t.index ["linkedin_profile_education_id"], name: "index_linkedin_schools_on_linkedin_profile_education_id"
  end

  create_table "mailboxer_conversation_opt_outs", id: :serial, force: :cascade do |t|
    t.string "unsubscriber_type"
    t.integer "unsubscriber_id"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", id: :serial, force: :cascade do |t|
    t.string "subject", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_notifications", id: :serial, force: :cascade do |t|
    t.string "type"
    t.text "body"
    t.string "subject", default: ""
    t.string "sender_type"
    t.integer "sender_id"
    t.integer "conversation_id"
    t.boolean "draft", default: false
    t.string "notification_code"
    t.string "notified_object_type"
    t.integer "notified_object_id"
    t.string "attachment"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.boolean "global", default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["notified_object_type", "notified_object_id"], name: "mailboxer_notifications_notified_object"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", id: :serial, force: :cascade do |t|
    t.string "receiver_type"
    t.integer "receiver_id"
    t.integer "notification_id", null: false
    t.boolean "is_read", default: false
    t.boolean "trashed", default: false
    t.boolean "deleted", default: false
    t.string "mailbox_type", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_delivered", default: false
    t.string "delivery_method"
    t.string "message_id"
    t.index ["message_id"], name: "index_mailboxer_receipts_on_message_id"
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
  end

  create_table "managed_accounts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "name"
    t.string "account_type"
    t.boolean "closed"
    t.index ["user_id"], name: "index_managed_accounts_on_user_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "subject"
    t.string "to"
    t.text "body"
    t.string "recipient_name"
    t.string "from"
    t.integer "person_id"
    t.index ["person_id"], name: "index_messages_on_person_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "multi_lookups", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "attributeid"
    t.string "rightentityid"
    t.string "rightentityid_type"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_multi_lookups_on_crelate_id"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["person_id"], name: "index_notes_on_person_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notified_objects", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "onsite_interviews", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "scheduled_time"
    t.integer "person_id"
    t.integer "call_sheet_id"
    t.integer "user_id"
    t.index ["call_sheet_id"], name: "index_onsite_interviews_on_call_sheet_id"
    t.index ["person_id"], name: "index_onsite_interviews_on_person_id"
    t.index ["user_id"], name: "index_onsite_interviews_on_user_id"
  end

  create_table "ownerships", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "attributeid"
    t.boolean "isprimary"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "rightentityid"
    t.string "rightentityid_type"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_ownerships_on_crelate_id"
  end

  create_table "participants", id: :serial, force: :cascade do |t|
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_participants_on_conversation_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "formatted_name"
    t.string "linkedin_profile_url"
    t.string "phone_number"
    t.string "search_text"
    t.string "keyword"
    t.string "location"
    t.string "employer"
    t.string "title"
    t.string "school"
    t.string "degree"
    t.string "discipline"
    t.string "name"
    t.integer "min_time_in_job"
    t.integer "max_time_in_job"
    t.integer "min_career_length"
    t.integer "max_career_length"
    t.integer "min_activity_date"
    t.integer "max_activity_date"
    t.boolean "email_available"
    t.boolean "linkedin_available"
    t.boolean "phone_number_available"
    t.boolean "github_available"
    t.boolean "top_company_status"
    t.integer "linkedin_profile_id_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_url"
    t.string "linkedin_profile"
    t.string "company_position"
    t.string "email_address", null: false
    t.string "linkedin_field_of_study"
    t.string "linkedin_industry"
    t.string "linkedin_profile_education"
    t.string "linkedin_profile_position"
    t.string "linkedin_profile_publication"
    t.text "linkedin_profile_recommendation"
    t.string "linkedin_profile_url_resource"
    t.string "linkedin_school"
    t.boolean "active"
    t.integer "user_id", null: false
    t.integer "note_id"
    t.boolean "flag"
    t.string "crelate_id"
    t.string "created_by_id"
    t.datetime "modified_on"
    t.string "updated_by_id"
    t.datetime "created_on"
    t.integer "salary"
    t.string "salutation"
    t.string "icon_attachment_id"
    t.string "primary_document_attachment_id"
    t.string "nickname"
    t.string "account_id"
    t.string "contact_number"
    t.string "twitter_name"
    t.string "contact_source_id"
    t.string "middle_name"
    t.string "suffix_id"
    t.string "ethnicity_id"
    t.string "gender_id"
    t.string "preferred_contact_method_type_id"
    t.string "last_activity_regarding_id"
    t.string "last_activity_regarding_id_type"
    t.datetime "last_activity_date"
    t.string "spoken_to"
    t.string "contact_status_id"
    t.string "contact_merge_id"
    t.string "approve_for_job_id"
    t.string "salary_details"
    t.string "record_type"
    t.string "description"
    t.datetime "created_on_system"
    t.integer "contact_num"
    t.string "skills"
    t.string "school_names"
    t.string "degrees"
    t.string "fields"
    t.string "company_names"
    t.string "createdbyid"
    t.datetime "modifiedon"
    t.string "updatedbyid"
    t.string "work_authorization_status"
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.boolean "top_one_percent_status"
    t.boolean "top_five_percent_status"
    t.boolean "top_ten_percent_status"
    t.string "status"
    t.integer "recruiter_update_id"
    t.boolean "recently_added"
    t.datetime "active_date_at"
    t.integer "active_set_by_user_id"
    t.integer "inbound_user_id"
    t.integer "phone_number_id"
    t.integer "person_id"
    t.string "remote_interest"
    t.string "position_interest"
    t.integer "experience_years"
    t.integer "supervising_num"
    t.string "salary_expectations"
    t.string "job_search_stage"
    t.string "position_desc"
    t.boolean "visa_status"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text "latest_pinned_note"
    t.integer "sms_last_from_user_id"
    t.string "github_url"
    t.string "stack_overflow_url"
    t.string "personal_site"
    t.boolean "personal_site_available"
    t.boolean "stack_overflow_url_available"
    t.json "public_profile_url"
    t.json "api_standard_profile_request"
    t.json "industry"
    t.json "current_share"
    t.json "num_connections"
    t.json "num_connections_capped"
    t.json "summary"
    t.json "specialties"
    t.json "positions"
    t.json "picture_url"
    t.json "site_standard_profile_request"
    t.string "lever_candidate_id"
    t.integer "company_position_id"
    t.integer "linkedin_profile_id"
    t.integer "email_address_id"
    t.integer "linkedin_field_of_study_id"
    t.integer "linkedin_industry_id"
    t.integer "linkedin_profile_education_id"
    t.integer "linkedin_profile_position_id"
    t.integer "linkedin_profile_publication_id"
    t.integer "linkedin_profile_recommendation_id"
    t.integer "linkedin_profile_url_resource_id"
    t.integer "linkedin_school_id"
    t.integer "education_level"
    t.boolean "public"
    t.string "attached_document_file_name"
    t.string "attached_document_content_type"
    t.integer "attached_document_file_size"
    t.datetime "attached_document_updated_at"
    t.time "message_date"
    t.boolean "top_company"
    t.boolean "top_school"
    t.string "tags"
    t.string "original"
    t.index "to_tsvector('english'::regconfig, (((formatted_name)::text || ' '::text) || (name)::text))", name: "people_idx", using: :gin
    t.index "to_tsvector('english'::regconfig, (search_text)::text)", name: "people_search_text", using: :gin
    t.index ["account_id"], name: "index_people_on_account_id"
    t.index ["active"], name: "index_people_on_active", where: "(active IS TRUE)"
    t.index ["active_set_by_user_id"], name: "index_people_on_active_set_by_user_id"
    t.index ["approve_for_job_id"], name: "index_people_on_approve_for_job_id"
    t.index ["contact_merge_id"], name: "index_people_on_contact_merge_id"
    t.index ["contact_source_id"], name: "index_people_on_contact_source_id"
    t.index ["contact_status_id"], name: "index_people_on_contact_status_id"
    t.index ["created_by_id"], name: "index_people_on_created_by_id"
    t.index ["crelate_id"], name: "index_people_on_crelate_id"
    t.index ["email_address"], name: "index_people_on_email_address", unique: true
    t.index ["email_available"], name: "index_people_on_email_available", where: "(email_available IS TRUE)"
    t.index ["ethnicity_id"], name: "index_people_on_ethnicity_id"
    t.index ["gender_id"], name: "index_people_on_gender_id"
    t.index ["github_available"], name: "index_people_on_github_available", where: "(github_available IS TRUE)"
    t.index ["icon_attachment_id"], name: "index_people_on_icon_attachment_id"
    t.index ["inbound_user_id"], name: "index_people_on_inbound_user_id"
    t.index ["last_activity_regarding_id"], name: "index_people_on_last_activity_regarding_id"
    t.index ["lever_candidate_id"], name: "index_people_on_lever_candidate_id"
    t.index ["linkedin_available"], name: "index_people_on_linkedin_available", where: "(linkedin_available IS TRUE)"
    t.index ["linkedin_profile_id_id"], name: "index_people_on_linkedin_profile_id_id"
    t.index ["note_id"], name: "index_people_on_note_id"
    t.index ["phone_number_available"], name: "index_people_on_phone_number_available", where: "(phone_number_available IS TRUE)"
    t.index ["recently_added"], name: "index_people_on_recently_added", where: "(recently_added IS TRUE)"
    t.index ["top_five_percent_status"], name: "index_people_on_top_five_percent_status", where: "(top_five_percent_status IS TRUE)"
    t.index ["top_one_percent_status"], name: "index_people_on_top_one_percent_status", where: "(top_one_percent_status IS TRUE)"
    t.index ["top_ten_percent_status"], name: "index_people_on_top_ten_percent_status", where: "(top_ten_percent_status IS TRUE)"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.integer "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "phone_interviews", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "scheduled_time"
    t.integer "person_id"
    t.integer "call_sheet_id"
    t.integer "user_id"
    t.index ["call_sheet_id"], name: "index_phone_interviews_on_call_sheet_id"
    t.index ["person_id"], name: "index_phone_interviews_on_person_id"
    t.index ["user_id"], name: "index_phone_interviews_on_user_id"
  end

  create_table "phone_numbers", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.datetime "createdon"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "categorytypeid"
    t.string "value"
    t.boolean "isprimary"
    t.string "extension"
    t.datetime "createdonsystem"
    t.string "crelate_id"
    t.integer "people_id"
    t.boolean "invalid_phone"
    t.boolean "credible"
    t.string "source"
    t.string "valid_since"
    t.string "last_seen"
    t.integer "country_code"
    t.string "display"
    t.string "display_international"
    t.integer "user_id"
    t.index ["people_id"], name: "index_phone_numbers_on_people_id"
    t.index ["person_id"], name: "index_phone_numbers_on_person_id"
  end

  create_table "placements", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "person_id"
    t.integer "call_sheet_id"
    t.integer "user_id"
    t.datetime "placement_date"
    t.index ["call_sheet_id"], name: "index_placements_on_call_sheet_id"
    t.index ["person_id"], name: "index_placements_on_person_id"
    t.index ["user_id"], name: "index_placements_on_user_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.integer "user_id"
    t.string "subject"
    t.string "to"
    t.string "from"
    t.text "raw_text"
    t.text "raw_body"
    t.binary "attachments"
    t.text "headers"
    t.text "raw_headers"
    t.index ["person_id"], name: "index_posts_on_person_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "private_conversations", id: :serial, force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "sender_id"], name: "index_private_conversations_on_recipient_id_and_sender_id", unique: true
    t.index ["recipient_id"], name: "index_private_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_private_conversations_on_sender_id"
  end

  create_table "private_messages", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "conversation_id"
    t.boolean "seen", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_private_messages_on_conversation_id"
    t.index ["user_id"], name: "index_private_messages_on_user_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_questions_on_person_id"
  end

  create_table "recruiter_updates", id: :serial, force: :cascade do |t|
    t.string "status"
    t.text "notes"
    t.date "date"
    t.string "role"
    t.string "client"
    t.string "lead_source"
    t.string "email"
    t.string "phone_number"
    t.string "visa"
    t.string "company"
    t.string "school"
    t.string "linkedin_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "first_name"
    t.string "last_name"
    t.string "name"
    t.integer "person_id"
    t.boolean "archived"
    t.integer "status_id"
    t.integer "job_id"
    t.integer "account_id"
    t.integer "category_id"
    t.string "location"
    t.string "email_address"
    t.string "work_authorization_status"
    t.string "salary_details"
    t.integer "salary"
    t.string "salutation"
    t.string "linkedin_profile_url"
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.string "document"
    t.integer "inbound_user_id"
    t.string "skills"
    t.string "title"
    t.string "degree"
    t.boolean "active_status"
    t.integer "managed_account_id"
    t.index ["account_id"], name: "index_recruiter_updates_on_account_id"
    t.index ["category_id"], name: "index_recruiter_updates_on_category_id"
    t.index ["inbound_user_id"], name: "index_recruiter_updates_on_inbound_user_id"
    t.index ["job_id"], name: "index_recruiter_updates_on_job_id"
    t.index ["managed_account_id"], name: "index_recruiter_updates_on_managed_account_id"
    t.index ["person_id"], name: "index_recruiter_updates_on_person_id"
    t.index ["status_id"], name: "index_recruiter_updates_on_status_id"
    t.index ["user_id"], name: "index_recruiter_updates_on_user_id"
  end

  create_table "saved_candidates", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_saved_candidates_on_person_id"
    t.index ["user_id"], name: "index_saved_candidates_on_user_id"
  end

  create_table "searched_candidates", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_searched_candidates_on_person_id"
    t.index ["user_id"], name: "index_searched_candidates_on_user_id"
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.string "search_texts"
    t.string "locations"
    t.string "company_names"
    t.string "titles"
    t.string "schools"
    t.string "degrees"
    t.string "disciplines"
    t.string "names"
    t.integer "min_time_in_job"
    t.integer "max_time_in_job"
    t.integer "min_career_length"
    t.integer "max_career_length"
    t.integer "min_activity_date"
    t.integer "max_activity_date"
    t.boolean "email_available"
    t.boolean "linkedin_available"
    t.boolean "phone_number_available"
    t.boolean "github_available"
    t.boolean "top_company_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "keyword"
    t.integer "user_id"
    t.string "emails"
    t.string "phone_numbers"
    t.string "linkedin_urls"
    t.boolean "active"
    t.boolean "candidates_without_notes"
    t.boolean "top_one_percent_status"
    t.boolean "top_five_percent_status"
    t.boolean "top_ten_percent_status"
    t.boolean "recently_added"
    t.boolean "candidates_with_notes"
    t.integer "experience_years"
    t.boolean "job_type_full_time"
    t.boolean "job_type_contract"
    t.boolean "relocation"
    t.boolean "remote"
    t.integer "person_id"
    t.string "skills"
    t.string "first_names"
    t.string "last_names"
    t.boolean "top_school"
    t.integer "min_education_level"
    t.boolean "top_company_or_top_school"
    t.boolean "all_candidates"
    t.boolean "fulltime_candidates"
    t.boolean "freelance_candidates"
    t.boolean "open_to_new_opportunities"
    t.boolean "willing_to_work_remote"
    t.date "message_date"
    t.boolean "top_company"
    t.string "tags"
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

# Could not dump table "seer_weather_prophecies" because of following StandardError
#   Unknown type 'weather_temperature' for column 'temperature'

  create_table "static_list_items", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.datetime "createdonsystem"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "viewid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_static_list_items_on_crelate_id"
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "recruiter_update_id"
    t.string "name"
    t.integer "person_id"
    t.string "lever_id"
    t.index ["lever_id"], name: "index_statuses_on_lever_id"
    t.index ["person_id"], name: "index_statuses_on_person_id"
    t.index ["recruiter_update_id"], name: "index_statuses_on_recruiter_update_id"
  end

  create_table "submittals", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "submitted_at"
    t.integer "person_id"
    t.integer "call_sheet_id"
    t.integer "user_id"
    t.string "crelate_id"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.datetime "modifiedon"
    t.datetime "createdon"
    t.string "jobid"
    t.string "emailbody"
    t.string "emailsubject"
    t.string "emailto"
    t.string "emailcc"
    t.string "emailbcc"
    t.string "emailfrom"
    t.string "emailfromid"
    t.datetime "createdonsystem"
    t.string "credentialid"
    t.string "phone_number"
    t.string "email_address"
    t.string "linkedin_profile_url"
    t.index ["call_sheet_id"], name: "index_submittals_on_call_sheet_id"
    t.index ["crelate_id"], name: "index_submittals_on_crelate_id"
    t.index ["person_id"], name: "index_submittals_on_person_id"
    t.index ["user_id"], name: "index_submittals_on_user_id"
  end

  create_table "submitted_candidates", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "user_id"
    t.integer "account_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "employer_id"
    t.boolean "hidden_status"
    t.index ["account_id"], name: "index_submitted_candidates_on_account_id"
    t.index ["employer_id"], name: "index_submitted_candidates_on_employer_id"
    t.index ["job_id"], name: "index_submitted_candidates_on_job_id"
    t.index ["person_id"], name: "index_submitted_candidates_on_person_id"
    t.index ["user_id"], name: "index_submitted_candidates_on_user_id"
  end

  create_table "submitted_requests", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "user_id"
    t.integer "account_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "candidate_id"
    t.boolean "hidden_status"
    t.integer "recruiter_id"
    t.index ["account_id"], name: "index_submitted_requests_on_account_id"
    t.index ["candidate_id"], name: "index_submitted_requests_on_candidate_id"
    t.index ["job_id"], name: "index_submitted_requests_on_job_id"
    t.index ["person_id"], name: "index_submitted_requests_on_person_id"
    t.index ["recruiter_id"], name: "index_submitted_requests_on_recruiter_id"
    t.index ["user_id"], name: "index_submitted_requests_on_user_id"
  end

  create_table "tag_relationships", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "rightentityid"
    t.string "rightentityid_type"
    t.string "rightentitytagcategoryid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_tag_relationships_on_crelate_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "name"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "tagcategoryid"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["crelate_id"], name: "index_tags_on_crelate_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "task_list_items", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "attributeid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "rightentityid"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_task_list_items_on_crelate_id"
  end

  create_table "timeline_items", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.boolean "isprimary"
    t.string "attributeid"
    t.datetime "whenstart"
    t.datetime "whenend"
    t.string "whatid"
    t.string "whatid_type"
    t.string "whereid"
    t.string "whereid_type"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "whatvalue"
    t.datetime "createdonsystem"
    t.index ["crelate_id"], name: "index_timeline_items_on_crelate_id"
  end

  create_table "unsubscribers", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.integer "person_id"
    t.integer "user_id"
    t.index ["person_id"], name: "index_uploads_on_person_id"
  end

  create_table "urls", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.datetime "createdon"
    t.string "categorytypeid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "value"
    t.boolean "isprimary"
    t.datetime "createdonsystem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_urls_on_crelate_id"
  end

  create_table "usabilities", force: :cascade do |t|
    t.string "f1"
    t.integer "f2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_contact_preferences", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.date "followup_date"
    t.boolean "subscribe_candidate_matches"
    t.boolean "subscribe_reminders"
    t.boolean "subscribe_all"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_contact_preferences_on_user_id"
  end

  create_table "user_educations", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_experiences", id: :serial, force: :cascade do |t|
    t.string "company_name"
    t.string "title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "user_profile_id"
    t.index ["user_id"], name: "index_user_experiences_on_user_id"
    t.index ["user_profile_id"], name: "index_user_experiences_on_user_profile_id"
  end

  create_table "user_mailing_addresses", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "country"
    t.boolean "legal_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone"
    t.index ["user_id"], name: "index_user_mailing_addresses_on_user_id"
  end

  create_table "user_profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.integer "role"
    t.string "name"
    t.string "full_name"
    t.integer "person_id"
    t.string "username"
    t.integer "notes_id"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "identity_id"
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "location"
    t.string "signuprole"
    t.string "phone_number"
    t.string "job_title"
    t.string "company_name"
    t.string "company_url"
    t.string "remote_interest"
    t.text "skills", default: [], array: true
    t.boolean "location_interest_bh"
    t.string "position_interest"
    t.string "experience_years"
    t.integer "supervising_num"
    t.string "salary_expectations"
    t.boolean "work_authorization_status"
    t.boolean "visa_status"
    t.string "linkedin_profile_url"
    t.string "github_url"
    t.string "personal_site"
    t.string "stack_overflow_url"
    t.text "position_desc"
    t.string "employment_sought"
    t.string "resume_file_name"
    t.string "resume_content_type"
    t.integer "resume_file_size"
    t.datetime "resume_updated_at"
    t.boolean "accepts"
    t.string "employer_hiring_location"
    t.string "employer_roles"
    t.string "employer_roles_type"
    t.boolean "employer_remoteness"
    t.string "employer_timeframe"
    t.boolean "employer_pricing_authorization"
    t.string "company_size"
    t.string "document_content_type"
    t.string "crelate_id"
    t.string "userstateid"
    t.datetime "accepts_date"
    t.string "job_search_stage"
    t.integer "account_manager_id"
    t.string "utf8"
    t.string "_method"
    t.string "authenticity_token"
    t.string "commit"
    t.string "current_position"
    t.string "current_employer"
    t.json "public_profile_url"
    t.json "api_standard_profile_request"
    t.json "industry"
    t.json "current_share"
    t.json "num_connections"
    t.json "num_connections_capped"
    t.json "summary"
    t.json "specialties"
    t.json "positions"
    t.json "picture_url"
    t.json "site_standard_profile_request"
    t.string "user"
    t.text "roles_held", array: true
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.text "location_interest_usa", default: [], array: true
    t.boolean "user_approved"
    t.string "referred_from"
    t.string "employer_hiring_roles"
    t.integer "bulk_message_count", default: 0, null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "google_token"
    t.string "google_refresh_token"
    t.index ["account_manager_id"], name: "index_users_on_account_manager_id"
    t.index ["crelate_id"], name: "index_users_on_crelate_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["identity_id"], name: "index_users_on_identity_id"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["notes_id"], name: "index_users_on_notes_id"
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "villagers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "villagerable_id"
    t.string "villagerable_type"
    t.index ["email"], name: "index_villagers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_villagers_on_reset_password_token", unique: true
    t.index ["villagerable_type", "villagerable_id"], name: "index_villagers_on_villagerable_type_and_villagerable_id"
  end

# Could not dump table "warriors" because of following StandardError
#   Unknown type 'warrior_role' for column 'role'

  create_table "workflow_items", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "label"
    t.datetime "modifiedon"
    t.datetime "createdon"
    t.string "createdbyid"
    t.string "updatedbyid"
    t.string "targetid"
    t.string "targetid_type"
    t.string "workflowitemstatusid"
    t.string "workflowid"
    t.string "applicationid"
    t.datetime "createdonsystem"
    t.string "target2id"
    t.string "target2id_type"
    t.string "name"
    t.string "workflowtargetentityid"
    t.string "workflowtargetentityid_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_workflow_items_on_crelate_id"
  end

  create_table "workflows", id: :serial, force: :cascade do |t|
    t.string "crelate_id"
    t.string "name"
    t.datetime "createdon"
    t.datetime "modifiedon"
    t.string "updatedbyid"
    t.string "createdbyid"
    t.string "targetentityid"
    t.string "targetentityid_type"
    t.string "workflowtypeid"
    t.string "statusid"
    t.datetime "createdonsystem"
    t.string "namepart2"
    t.string "namepart1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crelate_id"], name: "index_workflows_on_crelate_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "people"
  add_foreign_key "answers", "people"
  add_foreign_key "answers", "questions"
  add_foreign_key "archive_states", "people"
  add_foreign_key "call_sheets", "people"
  add_foreign_key "call_sheets", "users"
  add_foreign_key "calls", "call_sheets"
  add_foreign_key "calls", "people"
  add_foreign_key "comments", "people"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "company_positions", "email_addresses", name: "company_positions_email_address_id_fk"
  add_foreign_key "company_positions", "users"
  add_foreign_key "conversations", "users"
  add_foreign_key "email_addresses", "users", name: "email_addresses_user_id_fk"
  add_foreign_key "employer_company_profiles", "users"
  add_foreign_key "entries", "users"
  add_foreign_key "flagged_candidates", "people"
  add_foreign_key "flagged_candidates", "users"
  add_foreign_key "followed_candidates", "people"
  add_foreign_key "followed_candidates", "users"
  add_foreign_key "follows", "users"
  add_foreign_key "identities", "users", on_delete: :cascade
  add_foreign_key "intake_batches", "users"
  add_foreign_key "interviews", "users"
  add_foreign_key "job_location_interests", "users"
  add_foreign_key "job_searches", "users"
  add_foreign_key "jobs", "managed_accounts"
  add_foreign_key "jobs", "users"
  add_foreign_key "linked_accounts", "users"
  add_foreign_key "linkedin_industries", "linkedin_profiles"
  add_foreign_key "linkedin_industries", "linkedin_profiles", column: "linkedin_profiles_id"
  add_foreign_key "linkedin_profile_educations", "people", name: "linkedin_profile_educations_person_id_fk"
  add_foreign_key "linkedin_profile_educations", "users"
  add_foreign_key "linkedin_profile_positions", "users", name: "linkedin_profile_positions_user_id_fk"
  add_foreign_key "linkedin_profile_publications", "people"
  add_foreign_key "linkedin_profile_recommendations", "linkedin_profiles", name: "linkedin_profile_recommendations_linkedin_profile_id_fk"
  add_foreign_key "linkedin_profile_recommendations", "people"
  add_foreign_key "linkedin_profile_url_resources", "people"
  add_foreign_key "linkedin_profiles", "linkedin_profiles"
  add_foreign_key "linkedin_profiles", "users", name: "linkedin_profiles_user_id_fk"
  add_foreign_key "linkedin_schools", "linkedin_profile_educations"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "managed_accounts", "users", name: "managed_accounts_user_id_fk"
  add_foreign_key "messages", "people"
  add_foreign_key "messages", "users"
  add_foreign_key "onsite_interviews", "call_sheets"
  add_foreign_key "onsite_interviews", "people"
  add_foreign_key "onsite_interviews", "users"
  add_foreign_key "participants", "conversations"
  add_foreign_key "phone_interviews", "call_sheets"
  add_foreign_key "phone_interviews", "people"
  add_foreign_key "phone_interviews", "users"
  add_foreign_key "phone_numbers", "people"
  add_foreign_key "phone_numbers", "people", column: "people_id"
  add_foreign_key "placements", "call_sheets"
  add_foreign_key "placements", "people"
  add_foreign_key "placements", "users"
  add_foreign_key "posts", "people"
  add_foreign_key "posts", "users", name: "posts_user_id_fk"
  add_foreign_key "private_messages", "users"
  add_foreign_key "questions", "people"
  add_foreign_key "recruiter_updates", "accounts"
  add_foreign_key "recruiter_updates", "categories"
  add_foreign_key "recruiter_updates", "jobs"
  add_foreign_key "recruiter_updates", "managed_accounts"
  add_foreign_key "recruiter_updates", "people"
  add_foreign_key "recruiter_updates", "statuses", name: "recruiter_updates_status_id_fk"
  add_foreign_key "recruiter_updates", "users"
  add_foreign_key "saved_candidates", "people"
  add_foreign_key "saved_candidates", "users"
  add_foreign_key "searches", "users"
  add_foreign_key "statuses", "people"
  add_foreign_key "statuses", "recruiter_updates"
  add_foreign_key "submittals", "call_sheets"
  add_foreign_key "submittals", "people"
  add_foreign_key "submittals", "users"
  add_foreign_key "submitted_candidates", "accounts"
  add_foreign_key "submitted_candidates", "jobs"
  add_foreign_key "submitted_candidates", "people"
  add_foreign_key "submitted_candidates", "users"
  add_foreign_key "submitted_requests", "accounts"
  add_foreign_key "submitted_requests", "jobs"
  add_foreign_key "submitted_requests", "people"
  add_foreign_key "submitted_requests", "users"
  add_foreign_key "tags", "users"
  add_foreign_key "uploads", "people"
  add_foreign_key "uploads", "users", name: "uploads_user_id_fk"
  add_foreign_key "user_contact_preferences", "users"
  add_foreign_key "user_experiences", "user_profiles"
  add_foreign_key "user_experiences", "users"
  add_foreign_key "user_mailing_addresses", "users"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "users", "identities"
  add_foreign_key "users", "notes", column: "notes_id"
  add_foreign_key "users", "people"
end

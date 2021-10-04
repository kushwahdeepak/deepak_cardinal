require 'sidekiq/web'

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root  controller: 'welcome', action: 'home'
  # root to: 'welcome#employer'

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :submissions, only: [:create, :destroy] do
    collection do
      put :advance_stage
      put :reject
      get :my_submissions
      post :move_to_applicant_stage
      put :change_stage
      post :applied_jobs_list
    end
  end

  namespace :api do
    get 'submissions/get_metrics' => 'submissions#get_metrics'
    get 'submissions/mails_missing_submission' => 'submissions#mails_missing_submission'
  end

  post 'submissions', controller: 'submissions', action: 'create'
  post 'apply_to_all_matching_jobs', controller: 'submissions', action: 'apply_to_all_matching_jobs'

  post 'move_candidate_tostage', controller: 'people_searches', action: 'move_candidate_tostage'

  post 'incoming_mails/parse_plain', controller: 'incoming_mails', action: 'parse_plain'
  get 'incoming_mails/employer_response', controller: 'incoming_mails', action: 'employer_response'
  get 'incoming_mails/invitation_process', controller: 'incoming_mails', action: 'invitation_process'

  get 'welcome/employer'
  get 'welcome/recruiter'
  get 'welcome/on_demand_recruiter'
  get 'welcome/refer_for_rewards'
  get 'welcome/about_us'
  get 'welcome/careers'
  get 'welcome/company_careers'
  get 'welcome/cardinal_careers_page'
  get 'signup/contracts', controller: :sign_up_contracts, action: :show
  get 'signup/contracts/download', controller: :sign_up_contracts, action: :download
  get 'signup/lookups', controller: :sign_up_contracts, action: :lookups
  get 'signup/contracts/name/:name', controller: :sign_up_contracts, action: :show_name_wise
  get 'signup/contracts/role/:role', controller: :sign_up_contracts, action: :show_role_wise
  
  #this is used to  update  user profile from chrome extension
  put 'update_user_profile', controller: 'people', action: 'update_user_profile'

  resources :applicant_batches

  get 'privacy_policy', controller: 'policy', action: 'privacy_policy'
  get 'terms_of_service', controller: 'policy', action: 'terms_of_service'
  get 'jobs/searches', controller: 'jobs', action: 'search_jobs'
  get 'employer_home', controller: 'jobs', action: 'employer_home'
  get 'cardinal_jobs', controller: 'job_searches', action: 'cardinal_jobs'
  get 'single_candidate_upload', controller: 'jobs', action: 'single_candidate_upload'
  get 'bulk_candidate_upload', controller: 'jobs', action: 'bulk_candidate_upload'
  get 'talent_home', controller: 'welcome', action: 'talent_home'
  get 'candidates/new', controller: 'people', action: 'new'
  get 'job_search', controller: 'job_searches', action: 'show_job_search_page'
  get '/v2', controller: 'welcome', action: 'home_alt'
  get 'organization_name/:id', controller: 'jobs', action: 'organization_name'

  get 'jobs/:id/*others', controller: 'jobs', action: 'show'

  resources :after_signup, :candidate_searches, :incoming_mails, :intake_batches, :people_searches
  resources :organizations do
   
    resources :invitations
    collection do
      get '/:id/careers', controller: 'organizations', action: 'company_profile'
      get 'get_organization', controller: 'organizations', action: 'get_organization'
      get :exists
      get :pending
    end
    member do
      put :approve
      put :reject
    end
  end

  get '/recruiter_organizations',
      to: "recruiter_organizations#recruiter_organizations"  

  namespace :submitted_candidates do
    get 'build/show'
    get 'build/update'
    get 'build/create'
  end

  namespace :submitted_candidates do
    get 'build/show'
    get 'build/update'
    get 'build/create'
  end

  resources :uploads, only: [:index, :create, :destroy] do
    collection do
      get :list #list_uploads_url
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    post 'signup', to: 'users/registrations#create'
    post 'resend_confirmation', to:'users/registrations#resend_confirmation'
  end

  get 'dashboard', to: 'users#dashboard', as: 'user'

  resources :submitted_candidates, only: %i[show update], controller: 'submitted_candidate/build'

  resources :jobs do
    post :get_relevant_candidates, on: :collection
    post :fetch_submitted_candidates, on: :collection
    post :send_import_jobs
    put :extend_job
    post :guest_person_apply
    get :cardinal_member_organization_jobs, on: :collection
  end

  post '/messages/send_email_message',
       to: "messages#send_email_message",
       as: "send_email_message"

  post '/complete_submitted_candidate',
       to: 'submitted_candidates#complete_submitted_candidate',
       as: 'complete_submitted_candidate'

  get '/submitted_candidates_build_create_path',
      to: 'submitted_candidates/build#create',
      as: 'create'

  resources :submitted_candidates do
    resources :build, controller: 'submitted_candidates/build'
  end

  resources :users do
    collection do
      get :autocomplete
      get :profile
      get :exists
      get :get_email
    end
    get :index
    get :dashboard
    get :searched_candidates
    resources :call_sheets
    # resources :employer_company_profiles
    resources :user_contact_preferences
    resources :user_mailing_addresses
    resources :recruiter_updates do
      collection do
        post :import
        get :edit_multiple
        put :update_multiple
        put :delete_multiple
      end
    end
    resources :follows
    resources :submitted_candidates
    member do
      get :confirm_email
    end
  end

  resources :people do
    collection do
      get :edit_multiple
      put :update_multiple
      get :send_bulk_email_messages
      get :autocomplete
      post :search
      post :my_leads
      post 'new/single_candidate', action: 'add_single_candidate'
      post 'import_candidate', action: 'import_candidate_linkedin_url'
    end
    get :new_submission_from_member
    get :new_contact_from_member
    get :new_flag_for_review_from_member
    resources :notes
    resources :email_addresses
    resources :linkedin_profiles
    resources :phone_numbers
    resources :linkedin_profile_url_resources
    resources :saved_candidates
    resources :submitted_candidates
    resources :flagged_candidates
    resources :followed_candidates
  end


  namespace :webhook do
    resources :incoming_mails, only: [:create]
  end

  scope '/webhooks', controller: :webhooks do
    post :receive_candidate_hired
    post :receive_candidate_stage_change
    post :receive_candidate_archive_state_change
  end

  scope '/webhooks/cc', controller: :webhooks do
    post :receive_cc_webhook
  end

  resources :campaigns, only: %i[index show create] do
    collection do
      post :update_recipient_mail_status
    end
  end

  resources :match_scores, only: [:create] do
    collection do
      post :from_resume_anon
      post :from_resume
    end
  end
  get 'match_scores/talent/:id', to: 'match_scores#matched_jobs'

  resources :locations do
    collection do
      post :search
    end
  end

  resources :blacklists, only: [] do
    get :unsubscribe, on: :collection
  end

  resources :job_searches do
    post :search, on: :collection
    post :search_cardinal_jobs, on: :collection
  end


  resources :my_connections, only: [:index, :create] do
    collection do
      get :my_invitations
      get :unsubscribe
    end

    member do
      get :invite
      put :update_status
    end
  end

  # resources :interview_schedules, only: %i[index create update show ]
  
  post 'filter_candidate_on_company', to: 'company_profiles#filter_companys'
  post 'filter_candidate_on_location', to: 'locations#filter_locations'
  post 'filter_candidate_on_education', to: 'user_educations#filter_universities'

  resources :interview_schedules, only: %i[index create update show ] do
    get '/cancel', action: 'cancel'
  end

  resources :interview_feedbacks, only: %i[index create update show destroy] do
  end
  
  get '/interview_feedbacks/feedbacks/:id', to:'interview_feedbacks#feedbacks'
  get '/scheduled_interviews', to:'interview_schedules#scheduled_interviews'

  resources :resume_grades
  get 'retrieve_all_grades',
      to: "resume_grades#retrieve_all_grades"

  # TODO
  # Shift to oranization collection
  get 'get_users_in_organization',
      to: "organizations#get_users_in_organization"
  
  post 'search_recruiter', 
      to: "organizations#search_recruiter" 

  put 'remove_member_from_organization', 
      to: "organizations#remove_member_from_organization" 
  
  put 'change_recruiter_organization',
     to: "organizations#change_recruiter_organization"     

  post 'search_member', 
      to: "organizations#search_member"

  resources :job_experiences, only: [:index, :create] do
    collection do
      get '/delete/:id', to: 'job_experiences#delete_job_experience'
    end
  end

  resources :referrals

  namespace :users do
    resources :profile, only: [:show, :edit, :update]
    resources :unsubscribe, only: [:create, :show]
  end
  # opt out reason api for providing list of reasons user opting out
  scope module: 'users' do
    get '/unsubscribe/optout/reasons', controller: 'unsubscribe', action: 'optout_reasons'
  end

  # TODO 
  # move to seprate controller
  # for better routes 

  # company resourcs
  get '/company', controller: 'users', action: 'company'
  get '/account/setting', controller: 'users', action: 'setting'
  get '/account/security', controller: 'users', action: 'security'
  get '/account/email_verification', controller: 'users', action: 'email_verification'
  post 'user/security_update', controller: 'users', action: 'security_update'

  # Email verification (for managing recruiter campains)
  scope module: 'users' do
    post '/account/email_verification', controller: 'email_verification', action: 'send_verification_email'
    get '/account/email_verification/success', controller: 'email_verification', action: 'success'
    get '/account/email_verification/failure', controller: 'email_verification', action: 'failure'
  end

  resources :sign_up_contracts, only: [] do
    collection do
      put  :update_or_create
      post :update_or_create_lookup
    end
  end

  namespace :job do
    resources :previews, only: [:show]
  end

  namespace :admin do
    # resources :admins, only: [:index]
    get '/dashboard', controller: 'admins', action: 'index'
    get '/recruiter_management', controller: 'recruiters', action: :recruiter_management
    get '/organizations_management', controller: :organizations, action: :organizations_management
    get '/reference_data_management', controller: :references, action: :reference_data_management
    get '/get_users_and_admins', to: 'users#get_users_and_admins'
    put '/user/:id', controller: :admins, action: :update
    put '/exdend_job/:id', controller: :jobs, action: :update_expired
    # get '/jobs_list', controller: :jobs, action: :jobs_list
    resources :recruiter_organizations, only: %i[create destroy]

    resources :recruiters, only: [:index, :show ,:update, :destroy] do
      collection do
        get :pending
        get :get_recruiter_users
      end
      member do
        put :approve
        put :reject
      end
    end
    resources :organizations do
      collection do
        get :exists
        get :pending
        get :get_organization
      end
      member do
        put :approve
        put :reject
      end
    end

    resources :users
    resources :jobs
  end

  # resources :admins do
  #   collection do
  #     delete :destroy_org
  #   end
  # end

  resources :lookups, only: [:index, :update, :create, :destroy]

  resources :recruiters, only: [:index, :show ,:update, :destroy] do
    collection do
      get :pending
    end
    member do
      put :approve
      put :reject
    end
  end
  
  get 'get_users_and_admins', to: 'user_managements#get_users_and_admins'
  # get 'recruiter_management', controller: :admins, action: :recruiter_management
  # get 'organizations_management', controller: :admins, action: :organizations_management
  # get 'reference_data_management', controller: :admins, action: :reference_data_management
  get 'search_for_organization', controller: :organizations, action: :search_for_organization
  get 'download_resume', controller: :admins, action: :download_resume

  #email_sequence api
  post 'email_sequence/create', controller: :email_sequence, action: :create
  put 'email_sequence/update/:id', controller: :email_sequence, action: :update
  get 'email_sequence/:job_id', controller: :email_sequence, action: :show
  post 'email_sequence/bulk_upload/:email_sequence_id', controller: :email_sequence, action: :bulk_upload
end

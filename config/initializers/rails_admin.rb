require 'i18n'
include Pundit

I18n.default_locale = :en

RailsAdmin.config do |config|
  config.parent_controller = '::ApplicationController'
  config.main_app_name = Proc.new { |controller| [ "CardinalTalent", "BackOffice - #{controller.params[:action].try(:titleize)}" ] }

  ## == Devise ==
  config.authenticate_with do
   warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  config.attr_internal_accessor { _current_user.role.to_sym }

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.included_models = [
    "User",
    "Note",
    "Search",
    "Organization",
  #"Person"
  ]

  config.actions do
    dashboard
    index                         # mandatory
    new do
      except ['User']
    end
    export
    bulk_delete
    show
    edit
    delete
  end

  config.model 'User' do
    # show email instead of numeric id for users
    object_label_method do
      :email
    end

    #in the edit screen show these fields
    edit do
      field :first_name
      field :last_name
      field :email do
        read_only true
      end
      field :role
    end

    #in the list screen show these fiuelds
    list do
      field :first_name
      field :last_name
      field :id
      field :email
      field :created_at
      field :role
      field :recent_notes_count
      field :recent_candidate_contributions do
        label "candidates"
      end
    end
  end

  config.model 'Person' do
    #use Candidate instead of Person in Admin UI
    label 'Candidate'
    #use email to refer to specific candidates instead of numeric id
    object_label_method do
      :email_address
    end
  end

  config.model 'Note' do
    list do
      field :id
      field :user do
        queryable true
        searchable [:first_name, :last_name, :email]
      end
      field :person do
        queryable true
        searchable [:name, :email_address, :first_name, :last_name]
      end
      field :created_at
      field :body
    end
  end

  config.model 'Organization' do
    # show email instead of numeric id for users
    object_label_method do
      :name
    end

    edit do
      field :name
      field :description
      field :owner
      field :status, :enum do
        enum { %w(pending approved declined) }
      end
      field :users
    end

    list do
      field :id
      field :name
      field :description
      field :owner
      field :status do
        queryable true
        searchable true
      end
      field :created_at
    end
  end

  ActiveRecord::Base.descendants.each do |imodel|
    config.model "#{imodel.name}" do
      base do
        fields do
          read_only true

          # If you want rules about inclusion or exclusion of fields to only apply at the model level,
          # you should include the following two lines. (This code should be in the initializer in order
          # to run first and not clobber the `order` and `defined` attributes from your model config.)
          #
          # See also:
          #  - https://github.com/sferik/rails_admin/blob/v1.1.1/lib/rails_admin/config/has_fields.rb#L93-L94
          #  - https://github.com/sferik/rails_admin/blob/v1.1.1/lib/rails_admin/config/lazy_model.rb#L26-L47
          #
          self.defined = false
          self.order = nil
        end
      end
    end
  end
end

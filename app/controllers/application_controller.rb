require 'will_paginate/array'
require "outgoing_emailer"

class ApplicationController < ActionController::Base
  include Pundit
  include SessionsHelper
  # include OutgoingEmailer

  protect_from_forgery prepend: true, with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_metas


  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def self.super_debug_logging e
    if ENV['SUPERDEBUG']
      logger.error(e.full_message)
    end
  end

  rescue_from StandardError do |e|
    ApplicationController.super_debug_logging e
    raise e
  end

  before_action :set_user, only: [:show, :edit, :update], unless: :devise_controller?
  before_action :ensure_signup_complete, only: [:new, :create, :update]
  before_action :opened_conversations_windows
  before_action :all_ordered_conversations
  before_action :set_user_data, unless: :devise_controller?
  before_action :set_current_user, unless: :devise_controller?
  before_action :setup_job_action, if: :devise_controller?
  before_action :redirect_to_job, if: :devise_controller?

  respond_to :html, :json

  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end

  def ensure_signup_complete
    # Redirect to the 'finish_signup' page if the user email hasn't
    # been verified yet
    if current_user && current_user.email.blank?
      redirect_to finish_signup_path(current_user)
    end
  end

  def all_ordered_conversations
    if user_signed_in?
      @all_conversations = OrderConversationsService.new({user: current_user}).call
    end
  end

  # Todo
  # make template
  def render_404
    Rails.logger.debug "Record you trying to access not found"
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render_404
  end

  def render_bad_request!
    Rails.logger.debug "It seem cloudmail credentials not matched or attacment not found..."
    render json: {message: 'Unauthorized incoming mail request'}, status: 401
  end
  
  protected

  def set_user
    @user = current_user
  end

  def set_current_user
    User.current_user = current_user
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def opened_conversations_windows
    if user_signed_in?
      # opened conversations
      session[:private_conversations] ||= []
      session[:group_conversations] ||= []
      @private_conversations_windows = Private::Conversation.includes(:recipient, :messages)
      .find(session[:private_conversations])
      @group_conversations_windows = Group::Conversation.find(session[:group_conversations])
    else
      @private_conversations_windows = []
      @group_conversations_windows = []
    end
  end

  def resource_class
    User
  end

  def redirect_if_not_signed_in
    redirect_to root_path if !user_signed_in?
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end


  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? nil : user.id
  end

  def configure_permitted_parameters
    added_attrs = [:email, :name, :first_name, :last_name, :signuprole, :location, :username, :authenticity_token, :remember_me, :password, :password_confirmation, :current_password, :encrypted_password, :confirmation_token, :confirmation_sent_at, :unconfirmed_email, :password_required, :nickname, :sign_in, :invitation_accepted_at, :updated_at, :confirmed_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :last_sign_in_ip, :updated_at, :accepts, :accepts_date]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
    devise_parameter_sanitizer.permit(:sign_in, keys: added_attrs)
  end

  def set_user_data
    if user_signed_in?
      cookies[:user_id] = current_user.id if current_user.present?
      cookies[:group_conversations] = current_user.group_conversations.ids
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def page_from_params
    @page = params[:page] = [params[:page].to_i, 1].max
  end

  # Tracking user clicking Invite Friends option from public Job page
  def setup_job_action
    if params[:invite_friends].present? && params[:job_id].present?
      session[:invite_friends] = true
      session[:job_id] = params[:job_id]
    end

    return if session[:referral_token].blank?
    session[:invite_friends] = true if params[:invite_friends].present?
  end

  def redirect_to_job
    if params[:apply_job].present? && params[:job_id].present?
      session[:job_id] = params[:job_id]
      session[:apply_job] = true
    end
  end

  def initialize_metas
    @meta = { title: controller_name.titleize }
  end

end

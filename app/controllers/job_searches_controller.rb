
class JobSearchesController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!, except: [:create, :show, :search, :show_job_search_page]
  before_action :set_user, only: [:show, :edit, :update]

  respond_to :html, :json

  def new
    @job_search = JobSearch.new
    authorize @job_search

    if current_user.role == 'employer' || current_user.role == 'recruiter'
      @job_search.active = true
    end

    @searches = current_user.searches.last(3)
  end

  def filter
    @job_search = JobSearch.new
    authorize @job_search

    @searches = current_user.searches.last(3)
    redirect_to @job_search
  end

  def edit
    @job_search = JobSearch.find(job_search_params[:id])
    authorize @job_search
  end

  def create
    @job_search = JobSearch.new(job_search_params_to_attributes)
    @user = current_user
    if @job_search.save
      current_user.job_searches << @job_search if current_user
      respond_to do |format|
        format.json { render json: @job_search }
      end
    else
      flash[:error] = "There was an error performing this search. Please try again."
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @job_search = JobSearch.find(params[:id])
    @jobs = @job_search.query_search_engine_get_jobs page: params[:page]
    @total_entries = @jobs.total_entries
    job_location = Location.where(id:@job_search.locations).select(:country, :state, :city).first if @job_search.locations.present?
    @job_search[:locations] = "#{job_location.country}, " + "#{job_location.state}, " +"#{job_location.city}" if job_location.present?
    if current_user&.role == 'talent'
      @jobs = @jobs.map do |job|
        job_hash = job.to_hash
        job_hash[:score] = job.match_scores.all.select { |score| score.person_id == current_user.person_id }[0].score if current_user.person_id
        job_hash
      end
    else
      @jobs
    end
    respond_to do |format|
      format.html
      format.json { render json: {jobs: @jobs, jobsCount: @total_entries, jobSearch: @job_search} }
    end
  end

  def index
    @job_search = JobSearch.find(params[:id])
    if @job_search.present?
      @jobs = @job_search.query_search_engine_get_jobs
    else
      @job_search = JobSearch.new
      @jobs = Job.match_all_filter.records.order(created_at: :desc).paginate(page: 1, per_page: 25)
    end
  end

  def search
    if params['show_my_jobs'].present?
      show_my_jobs = params['show_my_jobs'].present? ? ActiveRecord::Type::Boolean.new.cast(params['show_my_jobs']) : true
      show_my_closed_jobs = params['show_my_closed_jobs'].present? ? ActiveRecord::Type::Boolean.new.cast(params['show_my_closed_jobs']) : false
      @job_search = EmployerJobsService.new(current_user, {keyword: params[:job_search][:keyword], job_keyword: params[:job_search][:job_keyword], page: page_from_params}, own_jobs: show_my_jobs, closed_jobs: show_my_closed_jobs)
      @job_search.call
      jobs = @job_search.jobs_data[:jobs]
      total_pages = @job_search.jobs_data[:total_pages]
      jobs_total_count = @job_search.jobs_data[:jobs_total_count]
    else
        if (attr = params[:job_search]&.select{|key, value| value.present? }).present?
          job_results =  attr[:keyword].present? ? Job.includes(:locations).references(:locations)
                                                    .where("LOWER(city) = :keyword OR LOWER(state)= :keyword",
                                                          keyword: attr[:keyword].downcase) : []
          
          if(job_results.present?)
            jobs = job_results.order(created_at: :desc).paginate(page: page_from_params, per_page: 10)
          else
            jobs = Job.search_jobs_with_filters(attr).records.order(created_at: :desc).paginate(page: page_from_params, per_page: 10)
          end
        else
          jobs = Job.match_all_filter.records.order(created_at: :desc).paginate(page: page_from_params, per_page: 10)
        end
      jobs_total_count = jobs.total_entries
      total_pages = jobs.total_pages
    end

    jobs = jobs.map { |job| JSON.parse(job.to_json({:include => :locations})).merge({ logo: job.to_hash[:logo] }) } unless current_user
    render json: { jobs: jobs.uniq, total_pages: total_pages, total_count: jobs_total_count  }
  end

  def cardinal_jobs
  end

  def show_job_search_page
  end

  def search_cardinal_jobs
    organization  = Organization.find_by(name: 'CardinalTalent')
    organization_jobs = organization&.jobs.where(active: true)
    organization.sub_organizations&.each do |sub_organization|
      organization_jobs += sub_organization&.jobs&.where(active: true)
    end
    if  params[:job_search][:keyword].present?
      searched_result = organization_jobs&.select{|a| a&.name&.downcase&.include? params[:job_search][:keyword]&.downcase}
    else
      searched_result = organization_jobs
    end  
    render json: {message: 'success', jobs: searched_result}
  end

  private

  def set_user
    @user = current_user
  end

  def job_search_params
    params
      .require(:job_search)
      .permit(
        :id,
        :skills,
        :keyword,
        :school_names,
        :experience_years,
        :title,
        :company_names,
        :locations
      )
  end

  def job_search_params_to_attributes
    if job_search_params[:location_id].present?
      locations = job_search_params[:location_id].map { |item| Location.find_by(id: item)&.to_str }
                                                .select { |item| item.present? }
                                                .join("; ")
    else
      locations = ''
    end
    attributes = { locations: locations}.merge(job_search_params)
    attributes.reject! { |k| k == 'location_id' }
    attributes
  end

  def user_not_authorized
    flash[:alert] = "Your account needs to be reviewed and approve before you can perform searches."
    redirect_to(request.referrer || '/')
  end
end

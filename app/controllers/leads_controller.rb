class LeadsController < ApplicationController
  include Pundit

  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  # GET /leads
  def index
    @leads = Lead.all
  end

  # GET /leads/1
  def show
  end

  # GET /leads/new
  def new
    @lead = Lead.new

    skip_authorization
  end

  # GET /leads/1/edit
  def edit
  end

  # POST /leads
  def create
    @lead = Lead.new(lead_params)

    respond_to do |format|
      if @lead.save
        LeadMailer.welcome_email(@lead).deliver_now

        @recruiter = User.where(email: 'alex@cardinalhire.com')
        @recruiter.invite!(:email => @lead.email)

        format.html { redirect_back(fallback_location: root_path, notice: "Thanks! CardinalTalent will find the latest jobs and update you with announcements.") }
        format.json { render json: @lead, status: :created, location: @lead }
      else
        format.html { redirect_back(fallback_location: root_path, notice: "Sorry, that didn't work. Please try signing up or creating an account again.") }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end

    skip_authorization
  end

  # PATCH/PUT /leads/1
  def update
    if @lead.update(lead_params)
      redirect_back(fallback_location: root_path)
      flash[:notice] = 'Thanks!'
    else
      render :edit
    end
  end

  # DELETE /leads/1
  def destroy
    @lead.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = 'Thanks!'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lead_params
      params.require(:lead).permit(:email, :name, :device, :commit, :accepts_date, :accepts, :name)
    end
end

class IntakeBatchesController < ApplicationController
  before_action :set_intake_batch, only: [:show, :edit, :update, :destroy]

  # GET /intake_batches
  # def index
  #   @intake_batches = IntakeBatch.all
  # end

  # GET /intake_batches/1
  def show
    @show_log = params[:log].present?

  end

  # GET /intake_batches/new
  def new
    @intake_batch = IntakeBatch.new
  end

  # # GET /intake_batches/1/edit
  # def edit
  # end

  # POST /intake_batches
  def create
    
    @intake_batch = IntakeBatch.new(intake_batch_params)
    @intake_batch.creator = current_user
    @intake_batch.model_klass = 'Person'

    if @intake_batch.save
      raise 'original file not attached to saved IntakeBatch.' unless @intake_batch.original_file.attached?
      redirect_to @intake_batch, notice: 'The batch has been queued for intake. Please record url of this page.
        You can check back here for current status of the batch.'
    else
      render :new, notice: 'Creation of batch failed.  Contact support.'
    end
  end

  # PATCH/PUT /intake_batches/1
  # def update
  #   if @intake_batch.update(intake_batch_params)
  #     redirect_to @intake_batch, notice: 'Intake batch was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /intake_batches/1
  # def destroy
  #   @intake_batch.destroy
  #   redirect_to intake_batches_url, notice: 'Intake batch was successfully destroyed.'
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intake_batch
      @intake_batch = IntakeBatch.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def intake_batch_params
      params.require(:intake_batch).permit(:original_file)
      #params.permit(:log)
    end
end

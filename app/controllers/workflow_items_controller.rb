class WorkflowItemsController < ApplicationController
  before_action :set_workflow_item, only: [:show, :edit, :update, :destroy]

  # GET /workflow_items
  def index
    @workflow_items = WorkflowItem.all
  end

  # GET /workflow_items/1
  def show
  end

  # GET /workflow_items/new
  def new
    @workflow_item = WorkflowItem.new
  end

  # GET /workflow_items/1/edit
  def edit
  end

  # POST /workflow_items
  def create
    @workflow_item = WorkflowItem.new(workflow_item_params)

    if @workflow_item.save
      redirect_to @workflow_item, notice: 'Workflow item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /workflow_items/1
  def update
    if @workflow_item.update(workflow_item_params)
      redirect_to @workflow_item, notice: 'Workflow item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /workflow_items/1
  def destroy
    @workflow_item.destroy
    redirect_to workflow_items_url, notice: 'Workflow item was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workflow_item
      @workflow_item = WorkflowItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def workflow_item_params
      params.fetch(:workflow_item, {})
    end
end

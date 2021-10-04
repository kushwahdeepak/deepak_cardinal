class SignUpContractsController < ApplicationController
  before_action :authenticate_user!, only: [:update_or_create]
  
  def show
    if params[:role].present?
  	  render json: SignUpContract::find_by_name_and_role(params[:name], params[:role])
    else
      render json: SignUpContract::find_by_name(params[:name])
    end
  end

  def update_or_create
    if current_user.admin?
      if params[:role].present?
        SignUpContract::update_or_create(params[:name], params[:role], params[:content])
      else
        [:talent, :employer, :recruiter].each do |role|
          SignUpContract::update_or_create(params[:name], role, params[:content])
        end
      end

      render json: { message: 'Success' }, status: :ok
    end
  end

  def update_or_create_lookup
    if current_user.admin?
      lookup = Lookup.where(name: params[:name], key: params[:key])

      if lookup.present?
        lookup.update(value: params[:value])
      else 
        Lookup.create(params)
      end

      render json: { message: 'Success' }, status: :ok
    end
  end

  def show_name_wise
	render json: SignUpContract.select(:id,:content, :role).where(name: params[:name]).all
  end

  def show_role_wise
	render json: SignUpContract.select(:id,:content,:name).where(role: params[:role]).all
  end

  def download
  	contract = SignUpContract::find_by_name_and_role(params[:name], params[:role])
  	pdf_kit = PDFKit.new(contract&.content, :page_size => 'Letter')
  	send_data(pdf_kit.to_pdf, filename: "#{contract&.name}_#{contract&.role}.pdf", type: 'application/pdf')
  end

  def lookups
  	signup_lookups = {
  	  states: Lookup.for_name(:state),
  	  industries: Lookup.for_name(:industry),
  	  company_sizes: Lookup.for_name(:company_size)
  	}
  	render json: signup_lookups
  end
  
end
class LookupsController < ApplicationController
	before_action :authenticate_user!

	RESULTS_PER_PAGE = 25

	def index
	  items = Lookup.for_name(params[:name]).as_json(with_id: true).paginate(page: params[:page], per_page: RESULTS_PER_PAGE)
	  total_pages = items.total_pages
	  render json: { items: items.as_json(with_id: true), total_pages: total_pages}
	end

	def create
	  lookup = Lookup.new(lookup_params)

	  if lookup.save
	  	render json: { item: lookup }
	  else
	  	render json: { error: 'Something went wrong!' }
	  end
	end

	def update
	  lookup = Lookup.find_by(id: params[:id])

	  if lookup.update(lookup_params)
	  	render json: { item: lookup }
	  else
	  	render json: { error: 'Something went wrong!' }
	  end
	end

	# DELETE /users/:id.:format
	def destroy
		
		if Lookup.find_by(id: params[:id]).destroy
			render json: { message: 'Your profile was successfully deleted.' }
		else
			render json: { error: 'Something went wrong!' }
		end
	end

	private

	def lookup_params
      params
      .require(:lookup)
      .permit(:name, :key, :value)
    end
end
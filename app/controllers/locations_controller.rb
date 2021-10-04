class LocationsController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def search
    location = params[:filter_word] || params[:location]
    render json: {
              locations: Location.query_search_engine_get_locations(location).records.paginate(:page => 1, :per_page => 20)
          }
  end

  def filter_locations
    if params[:flag]
      locations = Location.location_city_filter(params[:filter_word])
    else
      locations =  Location.location_state_filter(params[:filter_word])
    end
    render json: {filter: locations}
  end

  private

  def location_search_params
    params
      .permit(
        :location
      )
  end
end

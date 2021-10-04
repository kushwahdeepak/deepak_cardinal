class CompanyProfilesController < ApplicationController

  def filter_companys
    companys = CompanyProfile.filter_company(params[:filter_word]).first(300)
    render json: {filter: companys}
  end
end

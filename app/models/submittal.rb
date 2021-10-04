class Submittal < ApplicationRecord
  belongs_to :user
  belongs_to :person
  belongs_to :call_sheet


  private

  def submittal_params
    params.require(:submittal).permit(
      :submitted_at,
      :first_name,
      :last_name,
      :phone_number,
      :email_address,
      :linkedin_profile_url)
  end
end

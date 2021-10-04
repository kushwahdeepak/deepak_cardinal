class Placement < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :person
  belongs_to :call_sheet, optional: true

  private

  def placement_params
    params.require(:placement).permit(:scheduled_time)
  end
end

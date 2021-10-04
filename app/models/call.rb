class Call < ApplicationRecord
  belongs_to :call_sheet
  belongs_to :person

  private

  def call_params
    params.require(:call).permit(:scheduled_time, :first_name, :last_name)
  end
end

# RSpec.describe IntakeBatchesController do
#
#
#   xit "pamrs permits" do
#     params = ActionController::Parameters.new({
#       person: {
#         name: "Francesco",
#         age:  22,
#         role: "admin"
#       },
#       logs:true
#     })
#
#     permitted = params.require(:person).permit(:name, :age, :log)
#     permitted            # => <ActionController::Parameters {"name"=>"Francesco", "age"=>22} permitted: true>
#     permitted.permitted? #
#   end

  # def simulate_file_upload(fixture_nane)
  #   fixture_file_upload(Rails.root.join('spec/fixtures', fixture_nane), 'text/csv')
  # end
  # describe "POST /intake_batches" do
  #   it "creates a not-done IntakeBatchInstance" do
  #     request.params[:file] = simulate_file_upload 'batch_intake_mock_data.csv'
  #     post
  #   end
  #   it "rejects not-whitelisted params" do
  #
  #   end
  #
  #   it "responds with usefull feedback when invalid input" do
  #
  #   end
  #
  #
  # end
#end
class SampleWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    @user = User.find(user_id)
    if @user.signuprole == "employer"
      NewEmployerUserMailer.sample_email(@user).deliver
    end
  end
end

module Admins
  class CreateAdminService
    attr_reader :emails, :users

    def initialize(email)
      @email = email
      @user = User.without_role(:admin).find_by(email: email)
    end

    def call
      get_users
      update_user_role
      user
    end

    private

    def get_users
      mails = emails.split(', ')
      @users = User.without_role(:admin).where(email: mails)
    end

    def update_user_role
      users.each { |user| user.admin! }
    end
  end
end

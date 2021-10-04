namespace :update_users_approved_to_true do
  desc 'update system users user_approved column to true'
  task update_user_approved: :environment do
    User.where(user_approved: nil).update_all(user_approved: true)
  end
end

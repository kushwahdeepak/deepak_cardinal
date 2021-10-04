namespace :reports do
  def print_stats_per_user_for_model model
    model.
      unscoped.
      where(:created_at => (Date.today - 7)..(Date.today)).
      group(:user).
      count.
      to_a.
      map{ |e| [e.first ? e.first.email : nil, e.last] }.
      each{ |e| puts e.first + ' ' + e.last.to_s }
  end
  task weekly_new_people_notes: :environment do
    puts 'count of canqdidates created last week broken down by creators'
    print_stats_per_user_for_model Person
    puts 'count of notes created last week broken down by creators'
    print_stats_per_user_for_model Note
  end
end
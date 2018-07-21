namespace :user do
  namespace :meetings do
    # rake user:meetings:seed['user@example.com', 30]
    desc 'Destroy all user meetings.'
    task :destroy, [:email] => :environment do |_, args|
      email = args[:email]
      logger.info "Deleting all meetings for #{email} ..."
      user = User.where(email: args[:email]).first || raise("Cannot find user with e-mail #{email}.")
      count = user.meetings.count
      user.meetings.destroy_all
      logger.info "Deleted #{count} meeting(s)."
    end

    desc 'Seed a user with :days worth of meetings.'
    task :seed, %i[email days] => :environment do |_, args|
      email = args[:email]
      logger.info "Seeding #{email} ..."
      user = User.where(email: args[:email]).first || raise("Cannot find user with e-mail #{email}.")
      raise 'User already has meetings.' if user.meetings.any?
      days = (args[:days] || 10).to_i
      days.times do |i|
        puts "Day #{i + 1}:"
        meetings_today = rand(5)
        meetings_today.times do |_m|
          started_at = Faker::Time.backward(i)
          duration = rand(1..120).minutes
          finished_at = started_at + duration
          meeting = user.meetings.create!(
            title: Faker::Company.bs.capitalize,
            started_at: started_at,
            finished_at: finished_at
          )
          puts "  - #{meeting}"
        end
      end
    end

    desc '(Re)seed a user with :days worth of meetings.'
    task :reseed, %i[email days] => :environment do |_, args|
      Rake::Task['user:meetings:destroy'].invoke(* args)
      Rake::Task['user:meetings:seed'].invoke(* args)
    end
  end
end

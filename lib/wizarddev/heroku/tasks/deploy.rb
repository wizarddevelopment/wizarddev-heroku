task :deploy do
  if ENV['TARGET']
    Wizarddev::Heroku.load
    Wizarddev::Heroku::Deploy.new(ENV['TARGET']).deploy!
  else
    Rake::Task["deploy:help"].invoke
  end
end

namespace :deploy do
  desc 'Deploy script usage information'
  task :help do
    puts 'Deploys the currently checked out revision to heroku.'
    puts 'Reads the project\'s app.json file to determine tasks for a target.'
    puts 'Tasks include:'
    puts "\t Tag the release and pushes it to github"
    puts "\t Deploy the release to Heroku"
    puts "\t Execute commands remotely eg 'rake db:migrate'"
    puts "\t Restart the app"
    puts "\nUses the ~/.netrc file for authentication per the heroku toolbelt."
    puts "\nusage: rake deploy TARGET=target_name"
    puts "usage: rake deploy:{staging|production}"

    Wizarddev::Heroku.load
    Wizarddev::Heroku::Deploy.check_auth_config
    exit 0
  end

  desc 'Deploy to Production'
  task :production do
    Wizarddev::Heroku.load
    Wizarddev::Heroku::Deploy.new(:production).deploy!
  end

  desc 'Deploy to Staging'
  task :staging do
    Wizarddev::Heroku.load
    Wizarddev::Heroku::Deploy.new(:staging).deploy!
  end

end


module Wizarddev
  module Heroku
    class Railtie < Rails::Railtie
      generators do
        # require 'wizarddev/heroku/generators/app_json'
      end

      rake_tasks do
        require 'wizarddev/heroku/tasks/deploy'
      end
    end
  end
end

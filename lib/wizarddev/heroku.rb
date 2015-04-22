require "wizarddev/heroku/version"
require 'wizarddev/heroku/railtie' if defined?(Rails)

module Wizarddev
  module Heroku
    def self.load
      require 'wizarddev/heroku/platform_client'
      require 'wizarddev/heroku/deploy'
    end
  end
end


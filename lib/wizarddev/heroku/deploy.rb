require 'json'

module Wizarddev
  module Heroku
    class Deploy
      attr_reader :target, :heroku

      def self.check_auth_config
        unless auth = PlatformClient.load_auth
          puts "Please make sure you have an up to date version of the heroku toolbelt and it's logged in"
        end

        unless config = File.exist?('app.json')
          puts "Please include an app.json in the root of this project."
          puts "`rails g wizarddev:app_json` will make one for you."
        end

        exit(1) unless auth && config
      end

      def initialize(target)
        @target = target.to_s
        @app_config = load_config
        @heroku = PlatformClient.local_auth(app_name)
      end

      def deploy!
        force_push? ? force_push : push
        tag_deploy
        run_scripts
      end

      def push
        puts "Pushing HEAD to Heroku ..."
        execute "git push git@heroku.com:#{app_name}.git HEAD:master"
      end

      def force_push
        puts "Force pushing HEAD to Heroku ..."
        execute "git push -f git@heroku.com:#{app_name}.git HEAD:master"
      end

      def run_scripts
        scripts.each { |script| run_script(script) }
      end

      def tag_deploy
        return unless tag_name
        version = heroku.latest_release['version']
        release_name = "#{tag_name}/v#{version}"
        puts "Tagging release with #{release_name}"
        execute "git tag -a #{release_name} -m 'Tagged release'"
        execute "git push #{source_repo} #{release_name}"
      end

      def execute_remote(cmd)
        print "Executing '#{cmd}' on #{app_name}\n"
        output, code = heroku.run_with_code(cmd)
        puts output.gsub(/^/, "#\t")
        return true if code == 0
        puts "Failed to Execute #{cmd} with code #{code}"
        exit(1)
      end

      def execute(cmd)
        print "Executing '#{cmd}'\n"
        success = system(cmd)
        return true if success
        code = $CHILD_STATUS.to_i
        puts "Failed to Execute #{cmd} with code #{code}"
        exit(1)
      end

      private

      def run_script(script)
        if script["remote"]
          execute_remote script["cmd"]
        else
          execute script["cmd"]
        end
        restart if script["restart"]
      end

      def restart
        puts "Restarting #{app_name}"
        heroku.restart_all
      end

      def load_config
        YAML.load_file('deploy.yml')
      end

      def source_repo
        @app_config["source-repo"]
      end

      def tag_name
        config["tag-name"]
      end

      def force_push?
        !!config["force-push"]
      end

      def app_name
        config["app-name"]
      end

      def scripts
        config["scripts"]
      end

      def config
        c = @app_config["heroku-environments"][target]
        raise "No configuration for #{target} in app.js" unless c
        c
      end
    end
  end
end

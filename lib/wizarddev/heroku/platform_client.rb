require 'httparty'
require 'rendezvous'
require 'netrc'

module Wizarddev
  module Heroku
    class PlatformClient
      include HTTParty
      attr_reader :app
      base_uri 'https://api.heroku.com'

      def self.local_auth(app)
        new(load_auth.password, app)
      end

      def self.load_auth
        auth = Netrc.read['api.heroku.com']
      end

      def initialize(oauth_key, app)
        @app = app
        self.class.headers(
          'Accept' => 'application/vnd.heroku+json; version=3',
          'Authorization' => "Bearer #{oauth_key}"
        )
      end

      def latest_release
        resp = self.class.get(
          "/apps/#{app}/releases",
          headers: {
            'Range' => 'version ..; order=desc, max=1;'
          }
        )
        raise "Error fetching latest release: #{response.body}" unless resp.success?
        resp.first
      end

      def restart_all
        self.class.delete("/apps/#{app}/dynos")
      end

      def run(cmd)
        cmdstr = { attach: 'true', command: cmd }.to_json
        opt = {
          body: cmdstr,
          headers: { 'Content-Type' => 'application/json' }
        }
        response = self.class.post("/apps/#{app}/dynos", opt)
        session = Rendezvous.new(
          input: StringIO.new,
          output: StringIO.new,
          url: response['attach_url']
        )
        session.start
        session.output.rewind
        session.output.read
      end

      def run_with_code(cmd)
        cmd = "#{cmd}; echo $?"
        *output, code = run(cmd).split("\n")
        [output.join("\n"), code.to_i]
      end
    end
  end
end

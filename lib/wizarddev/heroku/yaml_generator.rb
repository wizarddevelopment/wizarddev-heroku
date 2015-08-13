module YamlGenerator
  def self.create
    app_name = ENV["HEROKU_APP_NAME"]
    deploy_name = ENV["HEROKU_DEPLOY_NAME"]
    repo_name = ENV["REPO_NAME"]
    app_url = ENV["APP_URL"]

    yaml_content = YAML.load_file('template.yml')
    yaml_content["source-repo"] = "git@github.com:#{repo_name}.com.git"
    yaml_content["website"] = app_url
    yaml_content["heroku-environments"]["staging"]["app-name"] = "#{deploy_name}-staging"
    yaml_content["heroku-environments"]["production"]["app-name"] = "#{deploy_name}-production"
    out_file = File.new("deploy.yml", "w")
    out_file.puts(yaml_content.to_yaml)
    out_file.close
  end
end

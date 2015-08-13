namespace :deployer do
  desc "Creates default deploy.yml file based on ENV variables"
  task :create_deploy_yaml do
    YamlGenerator.create
    puts "Generator Finished"
  end
end

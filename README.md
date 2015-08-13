# Wizarddev::Heroku

Deploys rails apps to heroku

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wizarddev-heroku'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wizarddev-heroku

## Usage
From `rake deploy`

```
Deploys the currently checked out revision to Heroku.
Reads the project's deploy.yml file to determine tasks for a target.
Tasks include:
   Tag the release and pushes it to github
   Deploy the release to Heroku
   Execute commands remotely eg 'rake db:migrate'
   Restart the app

Uses the ~/.netrc file for authentication per the Heroku toolbelt.

usage: rake deploy TARGET=target_name
usage: rake deploy:{staging|production}
```

## Example deploy.yml

This is very similar to Heroku's `app.json` but as a yml file

```yml
---
name: Our Cool App
description: Great app to use all the time.
website: "https://www.ourcoolapp.com"
heroku-environments:
  staging:
    app-name: "ourcoolapp-staging"
    tag-name: false
    force-push: true
    scripts:
      - cmd: "rake db:migrate"
        restart: true
        remote: true
      - cmd: "rake coolapp:do_something_on_deploy"
        remote: true
  production:
    app-name: "ourcoolapp-production"
    force-push: false
    tag-name: prod
    scripts:
      - cmd: "rake db:migrate"
        restart: true
        remote: true
      - cmd: "rake coolapp:do_something_on_deploy"
        remote: true
      - cmd: "say 'deploy complete'"
source-repo: "git@github.com:wizarddevelopment/ourcoolapp.git"

```


## Contributing

1. Fork it ( https://github.com/wizarddevelopment/wizarddev-heroku/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

source "http://rubygems.org"
source "http://gems.undev.cc" unless ENV["TRAVIS"]

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem "rails", "~> 4.1.0"

gem "protected_attributes"
gem 'rails-observers'

# Make links from text
gem 'rails_autolink', '~> 1.1'

# Default values for AR models
gem "default_value_for", "~> 3.0.0"

# Supported DBs
gem "pg"

# Auth
gem "devise", '3.0.4'
gem "devise-async", '0.8.0'
gem 'omniauth', "~> 1.1.3"
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-github'

# Browser detection
gem "browser"

# Search
gem 'elasticsearch-model',  github: 'elasticsearch/elasticsearch-rails',  ref: '88b6597e47c9f45024b603faeddb0a85b47e1fce'
gem 'elasticsearch-rails',  github: 'elasticsearch/elasticsearch-rails'
gem 'elasticsearch-git', github: 'zzet/elasticsearch-git', ref: '7065da063f31d2f0a2b7c6d237ed39fb704b4772'
gem 'jquery-friendly_id-rails'

# Extracting information from a git repository
# Provide access to Gitlab::Git library
gem "gitlab_git", '~> 6.0'
gem 'rugged'

# Ruby/Rack Git Smart-HTTP Server Handler
gem 'gitlab-grack', '~> 2.0.0.pre', require: 'grack'

# LDAP Auth
gem 'gitlab_omniauth-ldap', '1.0.4', require: "omniauth-ldap"

# Git Wiki
gem 'gollum-lib', '~> 3.0.0'

# Language detection
gem "gitlab-linguist", "~> 3.0.0", require: "linguist"

# API
gem "grape", "~> 0.6.1"
# Replace with rubygems when nesteted entities get released
gem "grape-entity", "~> 0.4.2"
gem 'rack-cors', require: 'rack/cors'

# Format dates and times
# based on human-friendly examples
gem "stamp"

# Enumeration fields
gem 'enumerize'

# Tree data structure
gem 'closure_tree'

# Pagination
gem "kaminari", "~> 0.15.1"

# HAML
gem "haml-rails"

# Files attachments
gem "carrierwave"

# Drag and Drop UI
gem 'dropzonejs-rails'

# for aws storage
#gem "fog", "~> 1.14", group: :aws
#gem "fog" #, "~> 1.3.1", group: :aws
gem "unf", group: :aws

# Authorization
gem "six"

# Seed data
gem "seed-fu"

# Markdown to HTML
gem "redcarpet",     "~> 3.1.2"
gem "github-markup"
gem "org-ruby" # For rendering .org files

# Diffs
gem 'diffy', '~> 3.0.3'

# Asciidoc to HTML
gem "asciidoctor"

#gem 'activerecord-msgpack_serializer', github: 'zzet/activerecord-msgpack_serializer'

# Application server
group :unicorn do
  gem "unicorn", '~> 4.6.3'
  gem 'unicorn-worker-killer'
end

gem "puma", '~> 2.3.1', group: :puma

#
gem 'request_store'

# State machine
gem "state_machine"

# Issue tags
gem "acts-as-taggable-on"

# Background jobs
gem 'slim'
gem 'sinatra', require: nil

# Resque 2.x
# gem "resque", "~> 2.0.0.pre.1", github: "resque/resque"
# gem 'resque-web', github: 'resque/resque-web', branch: "resque-2", require: 'resque_web'
# Resque 1.25
gem "resque"
gem 'resque-scheduler'
gem 'resque-web', require: 'resque_web'
gem 'resque-multi-job-forks'

# HTTP requests
gem "httparty"

# Colored output to console
gem "colored"

# GitLab settings
gem 'settingslogic'

# Misc
gem "foreman"
gem 'version_sorter'

# Cache
gem "redis-rails"

# Campfire integration
gem 'tinder', '~> 1.9.2'

# HipChat integration
gem "hipchat", "~> 0.14.0"

# Flowdock integration
gem "gitlab-flowdock-git-hook", "~> 0.4.2"

# Gemnasium integration
gem "gemnasium-gitlab-service", "~> 0.2"

# Slack integration
gem "slack-notifier", "~> 0.3.2"

# d3
gem "d3_rails", "~> 3.1.4"

# underscore-rails
gem "underscore-rails", "~> 1.4.4"

# Sanitize user input
gem "sanitize", '~> 2.0'

# Protect against bruteforcing
gem "rack-attack"

# Ace editor
gem 'ace-rails-ap'

# Semantic UI Sass for Sidebar
gem 'semantic-ui-sass', '~> 0.16.1.0'

gem "sass-rails", '~> 4.0.2'
gem "coffee-rails"
gem "uglifier"
gem "therubyracer"
gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'select2-rails'
gem 'jquery-atwho-rails', "~> 0.3.3"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "jquery-scrollto-rails"
gem "raphael-rails", "~> 2.1.2"
gem 'bootstrap-sass', '~> 3.0'
gem "font-awesome-rails", '~> 3.2'
gem "gitlab_emoji", "~> 0.0.1.1"
gem "gon", '~> 5.0.0'
gem 'nprogress-rails'
gem "js-routes"
gem 'react-rails', '~> 0.8.0.0'
gem "activerecord-import", "~> 0.4.1"

gem "private_pub"
gem 'thin', '~> 1.6.2'

group :development do
  gem "annotate", "~> 2.6.0.beta2"
  gem "letter_opener"
  gem 'quiet_assets', '~> 1.0.1'
  gem 'rack-mini-profiler', require: false

  # Better errors handler
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'rails_best_practices'

  # Docs generator
  gem "sdoc"
end

group :undev do
  # Deploy with Capistrano
  #gem "capi"
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'

  #gem 'capistrano'
  #gem 'capistrano-ext'
  #gem 'capistrano-maintenance'

  #gem 'undev', '>=0.2.1'
end

gem 'airbrake', '~> 3.1.16'
gem 'newrelic_rpm'

gem 'rb-inotify', require: linux_only('rb-inotify')

group :development, :staging, :test do
  # Visual email testing
  gem "mail_view", "~> 1.0.3"
  gem 'factory_girl_rails'
end

group :development, :test do
  gem 'coveralls', require: false
  # gem 'rails-dev-tweaks'
  gem 'spinach-rails'
  gem "rspec-rails"
  gem "capybara", '~> 2.2.1'
  gem "pry"
  gem 'pry-rails'
  # gem 'pry-rescue'
  # gem 'pry-remote'
  # gem 'pry-stack_explorer'
  # gem 'pry-debugger'
  gem "awesome_print"
  gem "database_cleaner"
  gem "launchy"

  # Prevent occasions where minitest is not bundled in packaged versions of ruby (see #3826)
  gem 'minitest', '~> 5.3.0'

  # Generate Fake data
  gem "ffaker"

  # Guard
  gem 'guard-rspec'
  gem 'guard-spinach'

  # Notification
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'growl',      require: darwin_only('growl')

  # PhantomJS driver for Capybara
  gem 'poltergeist', '~> 1.5.1'

  gem 'jasmine', '2.0.2'

  gem "spring", '1.1.1'
  gem "spring-commands-rspec", '1.0.1'
  gem "spring-commands-spinach", '1.0.0'
end

group :test do
  gem "simplecov", require: false
  gem 'simplecov-vim', require: false
  gem "shoulda-matchers", "~> 2.1.0"
  gem 'email_spec'
  gem "webmock"
  gem 'timecop'
  gem 'test_after_commit'
end

group :production do
  gem "gitlab_meta", '7.0'
end

@path = "https://raw.githubusercontent.com/zacharywelch/rails-api-template/master/templates"

get "#{@path}/README.md", 'README.md'
remove_file 'README.rdoc'
gsub_file 'README.md', /my_app_name/, @app_name

create_file 'config/database.yml.sample', File.read('config/database.yml')
create_file 'config/secrets.yml.sample', File.read('config/secrets.yml')

remove_file 'Gemfile'
create_file 'Gemfile'

add_source 'https://rubygems.org'

gem 'rails', '~> 4.2.5'
gem 'rails-api'
gem 'jbuilder'
gem 'responders'
#gem 'paginate-responder', git: 'git@github.com:zacharywelch/paginate-responder.git', branch: 'page-header'
#gem 'json_responder', git: 'git@cagit.careerbuilder.com:zwelch/json_responder.git'
#gem 'rails_api_filters', git: 'git@cagit.careerbuilder.com:zwelch/rails_api_filters.git'
#gem 'rails_api_sortable', git: 'git@cagit.careerbuilder.com:zwelch/rails_api_sortable.git'
gem 'faker'
gem 'kaminari'
gem 'newrelic_rpm'
gem 'solano'
gem 'capistrano'
gem 'capistrano-bundler'
gem 'capistrano-rvm'
gem 'exception_notification'
gem 'okcomputer'

append_to_file 'Gemfile', "\n\n\n"

gem_group :development do
  gem 'spring'
  gem 'annotate'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'
  gem 'sqlite3'
end

gem_group :test do
  gem 'simplecov', require: false
  gem 'shoulda-matchers', '~> 3.0'
  gem 'codeclimate-test-reporter', require: nil
end

gem_group :development, :staging, :production do
  gem 'tiny_tds', '~> 0.7.0'
  gem 'activerecord-sqlserver-adapter', '~> 4.2.10'
end

run 'bundle install'

generate 'rspec:install'
generate 'responders:install'

inject_into_file 'spec/rails_helper.rb',
  after: /require\s+['|"]rspec\/rails['|"]/ do <<-'RUBY'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.start
RUBY
end

gsub_file 'spec/rails_helper.rb',
  %r{# Dir\[Rails\.root\.join\('spec/support/\*\*/\*\.rb'\)\]\.each { \|f\| require f }},
  "Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }"

get "#{@path}/spec/support/shoulda_helper.rb", 'spec/support/shoulda_helper.rb', force: true

get "#{@path}/.gitignore", '.gitignore', force: true

run "newrelic install --license_key='d445e66d0037c4d9dfe1eb38137ff88c0c606455' #{@app_name}"

get "#{@path}/config/solano.yml", 'config/solano.yml'
get "#{@path}/lib/tasks/solano.rake", 'lib/tasks/solano.rake'
get "#{@path}/.codeclimate.yml", '.codeclimate.yml'
get "#{@path}/config/.rubocop.yml", 'config/.rubocop.yml'

run 'bundle exec cap install'
get "#{@path}/Capfile", 'Capfile', force: true
get "#{@path}/config/deploy.rb", 'config/deploy.rb', force: true
get "#{@path}/config/deploy/production.rb", 'config/deploy/production.rb', force: true
get "#{@path}/config/deploy/staging.rb", 'config/deploy/staging.rb', force: true
gsub_file 'config/deploy.rb', /my_app_name/, @app_name

inject_into_file 'config/application.rb',
                 after: /require\s+File.expand_path\(['|"]..\/boot['|"],\s+__FILE__\)/ do <<-'RUBY'

require 'ipaddr'
RUBY
end

inject_into_file 'config/application.rb',
                 after: /config.active_record.raise_in_transactional_callbacks = true/ do <<-'RUBY'


    # Only set localhost IPv4 and IPv6 as trusted proxies
    config.action_dispatch.trusted_proxies = %w(127.0.0.1 ::1).map { |proxy| IPAddr.new(proxy) }
RUBY
end
gsub_file "config/application.rb", /require "rails"/, '# require "rails"'
gsub_file "config/application.rb", /require "action_view\/railtie"/, '# require "action_view/railtie"'
gsub_file "config/application.rb", /require "sprockets\/railtie"/, '# require "sprockets/railtie"'

gsub_file "config/environments/production.rb", /:debug/, ':info'

get "#{@path}/config/initializers/okcomputer.rb", 'config/initializers/okcomputer.rb', force: true
get "#{@path}/config/initializers/exception_notification.rb", 'config/initializers/exception_notification.rb', force: true
get "#{@path}/config/initializers/activerecord_sql_adapter.rb", 'config/initializers/activerecord_sql_adapter.rb', force: true
#get "#{@path}/config/initializers/remote_ip.rb", 'config/initializers/remote_ip.rb', force: true
gsub_file "config/initializers/exception_notification.rb", /my_app_name/, @app_name
gsub_file "config/environments/production.rb", /# config.action_mailer.raise_delivery_errors = false/, <<-'RUBY'
config.action_mailer.raise_delivery_errors = true

  # Uncomment the following configurations for smtp delivery method via gmail.
  # Add related user_name and password to config/secrets.yml
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'gmail.com',
    user_name:            Rails.application.secrets.exception_email['user_name'],
    password:             Rails.application.secrets.exception_email['password'],
    authentication:       'login',
    enable_starttls_auto: true
  }
RUBY


gsub_file "config/environments/production.rb", /# config\.log_tags = \[ :subdomain, :uuid \]/, "config.log_tags = [:uuid, :remote_ip, :authorization]"

create_file "config/routes.rb", force: true do <<-'RUBY'
Rails.application.routes.draw do
  scope defaults: { format: :json } do
    # resources :users
  end
end
RUBY
end

environment do <<-'RUBY'

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.test_framework :rspec, view_specs: false, routing_specs: false,
                               controller_specs: false
    end

    config.log_tags = [:uuid, :remote_ip, :authorization]
RUBY
end

get "#{@path}/lib/application_responder.rb", 'lib/application_responder.rb', force: true
get "#{@path}/app/controllers/application_controller.rb", 'app/controllers/application_controller.rb', force: true
get "#{@path}/lib/templates/rails/responders_controller/controller.rb", 'lib/templates/rails/responders_controller/controller.rb', force: true

create_file 'config/environments/staging.rb', File.read('config/environments/production.rb')

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

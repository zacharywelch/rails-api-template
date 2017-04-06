@path = "https://raw.githubusercontent.com/zacharywelch/rails-api-template/master/templates"

remove_file 'README.rdoc'
get "#{@path}/README.md", 'README.md'
get "#{@path}/INSTALLATION.md", 'INSTALLATION.md'
get "#{@path}/CONTRIBUTING.md", 'CONTRIBUTING.md'
gsub_file 'README.md', /my_app_name/, @app_name
gsub_file 'INSTALLATION.md', /my_app_name/, @app_name
gsub_file 'CONTRIBUTING.md', /my_app_name/, @app_name

create_file 'config/database.yml.sample', File.read('config/database.yml')
create_file 'config/secrets.yml.sample', File.read('config/secrets.yml')

remove_file 'Gemfile'
create_file 'Gemfile'

CORPAPPS_GEMS_SERVER = 'https://corpapps-gems.cb.com'

add_source 'https://rubygems.org'
add_source CORPAPPS_GEMS_SERVER

gem 'rails', '~> 4.2.5'
gem 'rails-api'
gem 'jbuilder'
gem 'responders'
gem 'json_responder'
gem 'paginate-responder', source: CORPAPPS_GEMS_SERVER
gem 'rails_api_sortable'
gem 'partner_authentication'
gem 'faker'
gem 'kaminari'
gem 'newrelic_rpm'
gem 'exception_notification'
gem 'okcomputer'
gem 'lograge'
gem 'fluentd'
gem 'fluent-plugin-record-modifier'
gem 'rack-cors', require: 'rack/cors'

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
generate 'partner_authentication:install'

rake 'db:migrate'
rake 'db:authentication'

inject_into_file 'spec/rails_helper.rb',
  after: /require\s+['|"]rspec\/rails['|"]/ do <<-'RUBY'

require 'simplecov'
SimpleCov.start
RUBY
end

gsub_file 'spec/rails_helper.rb',
  %r{# Dir\[Rails\.root\.join\('spec/support/\*\*/\*\.rb'\)\]\.each { \|f\| require f }},
  "Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }"

get "#{@path}/spec/support/shoulda_helper.rb", 'spec/support/shoulda_helper.rb', force: true
get "#{@path}/spec/support/factory_girl.rb", 'spec/support/factory_girl.rb', force: true
get "#{@path}/lib/tasks/sample_data.rake", 'lib/tasks/sample_data.rake'

get "#{@path}/.gitignore", '.gitignore', force: true

run "newrelic install --license_key='d445e66d0037c4d9dfe1eb38137ff88c0c606455' #{@app_name}"

get "#{@path}/.codeclimate.yml", '.codeclimate.yml'
get "#{@path}/config/.rubocop.yml", 'config/.rubocop.yml'

inject_into_file 'config/application.rb',
                 after: /require\s+File.expand_path\(['|"]..\/boot['|"],\s+__FILE__\)/ do <<-'RUBY'

require 'ipaddr'
RUBY
end

inject_into_file 'config/application.rb',
                 after: /config.active_record.raise_in_transactional_callbacks = true/ do <<-'RUBY'


    # Only set localhost IPv4 and IPv6 as trusted proxies
    config.action_dispatch.trusted_proxies = %w(127.0.0.1 ::1).map { |proxy| IPAddr.new(proxy) }

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3000', 'stg-my_app_name.cb.com', 'my_app_name.cb.com'
        resource '/swagger', headers: :any, methods: :get
        unless Rails.env.production?
          resource '*', headers: :any, methods: :any
        end
      end
    end
RUBY
end
gsub_file "config/application.rb", /my_app_name/, @app_name
gsub_file "config/application.rb", /require "rails"/, '# require "rails"'
gsub_file "config/application.rb", /require "action_view\/railtie"/, '# require "action_view/railtie"'
gsub_file "config/application.rb", /require "sprockets\/railtie"/, '# require "sprockets/railtie"'

get "#{@path}/public/swagger.json", 'public/swagger.json'
get "#{@path}/app/controllers/swaggers_controller.rb", 'app/controllers/swaggers_controller.rb'
get "#{@path}/spec/requests/swaggers_spec.rb", 'spec/requests/swaggers_spec.rb'
gsub_file "public/swagger.json", /my_app_name/, @app_name

gsub_file 'config/environments/development.rb', /consider_all_requests_local(\s)*= true/, 'consider_all_requests_local       = false'
gsub_file 'config/environments/test.rb', /consider_all_requests_local(\s)*= true/, 'consider_all_requests_local       = false'
gsub_file 'config/environments/test.rb', /action_dispatch.show_exceptions = false/, 'action_dispatch.show_exceptions = true'

gsub_file "config/environments/production.rb", /:debug/, ':info'

get "#{@path}/config/initializers/okcomputer.rb", 'config/initializers/okcomputer.rb', force: true
get "#{@path}/config/initializers/exception_notification.rb", 'config/initializers/exception_notification.rb', force: true
get "#{@path}/config/initializers/activerecord_sql_adapter.rb", 'config/initializers/activerecord_sql_adapter.rb', force: true
get "#{@path}/config/initializers/remote_ip.rb", 'config/initializers/remote_ip.rb', force: true
gsub_file "config/initializers/exception_notification.rb", /my_app_name/, @app_name
gsub_file "config/environments/production.rb", /# config.action_mailer.raise_delivery_errors = false\n/, <<-'RUBY'
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

  config.middleware.use Rack::Deflater
RUBY

create_file "config/routes.rb", force: true do <<-'RUBY'
Rails.application.routes.draw do
  scope defaults: { format: :json } do
    # resources :users

    resource :swagger, only: :show
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

    # Lograge configuration
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.lograge.custom_options = lambda do |event|
      {
        date_time: Time.current,
        uuid: event.payload[:uuid],
        user_id: event.payload[:user_id],
        impersonated_user_id: event.payload[:impersonated_user_id],
        partner_id: event.payload[:partner_id],
        remote_ip: event.payload[:remote_ip],
        params: event.payload[:params]
          .except('controller', 'action', 'locale', 'format', '_method', 'id')
      }
    end
RUBY
end

inject_into_file 'config/environments/development.rb', after: /# config.action_view.raise_on_missing_translations = true\n/ do <<-'RUBY'

  # Lograge configuration
  config.lograge.keep_original_rails_log = true
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/#{Rails.env}_lograge.log"
RUBY
end

inject_into_file 'config/environments/test.rb', after: /# config.action_view.raise_on_missing_translations = true\n/ do <<-'RUBY'

  # Lograge configuration
  config.lograge.keep_original_rails_log = true
  config.lograge.logger = ActiveSupport::Logger.new "#{Rails.root}/log/#{Rails.env}_lograge.log"
RUBY
end

gsub_file "config/environments/production.rb", /# Prepend all log lines with the following tags.\n/, ""
gsub_file "config/environments/production.rb", /# config\.log_tags = \[ :subdomain, :uuid \]\n/, ""
gsub_file "config/environments/production.rb", /config.log_formatter =/, "# config.log_formatter ="
get "#{@path}/app/controllers/concerns/logging.rb", 'app/controllers/concerns/logging.rb'
get "#{@path}/config/fluentd.conf", 'config/fluentd.conf'

get "#{@path}/lib/application_responder.rb", 'lib/application_responder.rb', force: true
get "#{@path}/app/controllers/application_controller.rb", 'app/controllers/application_controller.rb', force: true
get "#{@path}/lib/templates/rails/responders_controller/controller.rb", 'lib/templates/rails/responders_controller/controller.rb', force: true

create_file 'config/environments/staging.rb', File.read('config/environments/production.rb')

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

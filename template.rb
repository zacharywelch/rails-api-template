@path = "https://cagit.careerbuilder.com/zwelch/rails-api-template/tree/master/templates"

copy_file 'README.rdoc', 'README.md'
remove_file 'README.rdoc'

remove_file 'Gemfile'
create_file 'Gemfile'

add_source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'rails-api'
gem 'sqlite3'
gem 'jbuilder'
gem 'responders'
gem 'json_responder', git: 'git@cagit.careerbuilder.com:zwelch/json_responder.git'
gem 'pagination_responder', git: 'git@cagit.careerbuilder.com:zwelch/pagination_responder.git'
gem 'rails_api_filters', git: 'git@cagit.careerbuilder.com:zwelch/rails_api_filters.git'
gem 'rails_api_sortable', git: 'git@cagit.careerbuilder.com:zwelch/rails_api_sortable.git'
gem 'faker'
gem 'kaminari'
gem 'newrelic_rpm'
gem 'solano'
gem 'capistrano'
gem 'capistrano-bundler'
gem 'capistrano-rvm'

append_to_file 'Gemfile', "\n\n\n"

gem_group :development do
  gem 'spring'
  gem 'annotate'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'
end

run 'bundle install'

generate 'rspec:install'
generate 'responders:install'

remove_file '.gitignore'
get "#{@path}/.gitignore", '.gitignore'

run "newrelic install --license_key='d445e66d0037c4d9dfe1eb38137ff88c0c606455' #{@app_name}"

get "#{@path}/config/solano.yml", 'config/solano.yml'
get "#{@path}/lib/tasks/solano.rake", 'lib/tasks/solano.rake'
prepend_to_file 'README.md', "[![](https://ci.solanolabs.com:443/caengineyarddev/REPLACE_WITH_BUILD_BAGDE)](https://ci.solanolabs.com:443/caengineyarddev/activities_api/suites/REPLACE_WITH_SUITE)\n\n"

run 'bundle exec cap install'
remove_file 'Capfile'
get "#{@path}/Capfile", 'Capfile'
remove_file 'config/deploy.rb'
get "#{@path}/config/deploy.rb", 'config/deploy.rb'
remove_file 'config/deploy/production.rb'
get "#{@path}/config/deploy/production.rb", 'config/deploy/production.rb'
remove_file 'config/deploy/staging.rb'
get "#{@path}/config/deploy/staging.rb", 'config/deploy/staging.rb'

gsub_file "config/application.rb", /require "rails"/, '# require "rails"'
gsub_file "config/application.rb", /require "action_view\/railtie"/, '# require "action_view/railtie"'
gsub_file "config/application.rb", /require "sprockets\/railtie"/, '# require "sprockets/railtie"'

remove_file 'config/routes.rb'
create_file "config/routes.rb" do <<-'RUBY'
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
RUBY
end

remove_file 'lib/application_responder.rb'
get "#{@path}/application_responder.rb", 'lib/application_responder.rb'

remove_file 'app/controllers/application_controller.rb'
get "#{@path}/application_controller.rb", 'app/controllers/application_controller.rb'

get "#{@path}/controller.rb", 'lib/templates/rails/responders_controller/controller.rb'

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

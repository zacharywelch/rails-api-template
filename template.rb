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

get "#{@path}/.gitignore", '.gitignore', force: true

run "newrelic install --license_key='d445e66d0037c4d9dfe1eb38137ff88c0c606455' #{@app_name}"

get "#{@path}/config/solano.yml", 'config/solano.yml'
get "#{@path}/lib/tasks/solano.rake", 'lib/tasks/solano.rake'
prepend_to_file 'README.md', "[![](https://ci.solanolabs.com:443/caengineyarddev/REPLACE_WITH_BUILD_BAGDE)](https://ci.solanolabs.com:443/caengineyarddev/activities_api/suites/REPLACE_WITH_SUITE)\n\n"

run 'bundle exec cap install'
get "#{@path}/Capfile", 'Capfile', force: true
get "#{@path}/config/deploy.rb", 'config/deploy.rb', force: true
get "#{@path}/config/deploy/production.rb", 'config/deploy/production.rb', force: true
get "#{@path}/config/deploy/staging.rb", 'config/deploy/staging.rb', force: true

gsub_file "config/application.rb", /require "rails"/, '# require "rails"'
gsub_file "config/application.rb", /require "action_view\/railtie"/, '# require "action_view/railtie"'
gsub_file "config/application.rb", /require "sprockets\/railtie"/, '# require "sprockets/railtie"'

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
RUBY
end

get "#{@path}/lib/application_responder.rb", 'lib/application_responder.rb', force: true
get "#{@path}/app/controllers/application_controller.rb", 'app/controllers/application_controller.rb', force: true
get "#{@path}/lib/templates/rails/responders_controller/controller.rb", 'lib/templates/rails/responders_controller/controller.rb', force: true

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

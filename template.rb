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
gem 'faker'
gem 'kaminari'

append_to_file 'Gemfile', "\n\n\n"

gem_group :development do
  gem 'spring'
  gem 'annotate'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

run 'bundle install' 

generate 'rspec:install'
generate 'responders:install'

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
create_file 'lib/application_responder.rb' do <<-'RUBY'
class ApplicationResponder < ActionController::Responder
  include Responders::HttpCacheResponder
  include Responders::JsonResponder
  include Responders::PaginationResponder
end
RUBY
end

remove_file 'app/controllers/application_controller.rb'
create_file 'app/controllers/application_controller.rb' do <<-'RUBY'
class ApplicationController < ActionController::API
  include ActionController::ImplicitRender

  self.responder = ApplicationResponder
  respond_to :json
end
RUBY
end

create_file 'lib/templates/rails/responders_controller/controller.rb' do <<-'RUBY'
<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :update, :destroy]

<% unless options[:singleton] -%>
  def index
    @<%= plural_table_name %> = <%= class_name %>.page(params[:page])
    respond_with(@<%= plural_table_name %>)
  end
<% end -%>

  def show
    respond_with(@<%= singular_table_name %>)
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, attributes_params) %>
    <%= "flash[:notice] = '#{class_name} was successfully created.' if " if flash? %>@<%= orm_instance.save %>
    respond_with(@<%= singular_table_name %>)
  end

  def update
    <%= "flash[:notice] = '#{class_name} was successfully updated.' if " if flash? %>@<%= orm_instance.update(attributes_params) %>
    respond_with(@<%= singular_table_name %>)
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_with(@<%= singular_table_name %>)
  end

  private
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
      <%- end -%>
    end
end
<% end -%>
RUBY
end

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
role :app, %w{deploy@example.com}
role :web, %w{deploy@example.com}
role :db,  %w{deploy@example.com}

server 'example.com', user: 'deploy', roles: %w{web app}

set :stage, :staging
set :rails_env, 'staging'
set :branch, :develop

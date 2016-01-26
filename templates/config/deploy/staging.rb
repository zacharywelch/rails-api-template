server 'example.com', user: 'deploy', roles: %w{web app}

set :stage, :staging
set :rails_env, 'staging'
set :branch, :develop

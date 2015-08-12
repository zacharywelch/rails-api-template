role :app, %w{deploy@example.com}
role :web, %w{deploy@example.com}
role :db,  %w{deploy@example.com}

server 'example.com', user: 'deploy', roles: %w{web app}

set :stage, :production
set :branch, :master

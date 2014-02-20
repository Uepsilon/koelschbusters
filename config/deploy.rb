set :application, "koelschbusters"

set :scm, :git
set :user, "koelschb"
set :repo_url,  "git@github.com:Uepsilon/koelschbusters.git"
set :deploy_to, "/var/www/virtual/koelschb/rails/koelschbusters/"

set :log_level, :debug

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp vendor/bundle public/system}

set :bundle_path, -> { "~/.gem" }
set :bundle_binstubs, nil

#set :default_env, { path: "~/.gem/ruby/2.0.0/bin:$PATH" }
SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"

set :keep_releases, 5

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  before :starting, :deploy do
    on roles(:all) do
      execute "/usr/bin/env > ~/.testFile"
    end
  end

  after :finishing, "deploy:cleanup"

end
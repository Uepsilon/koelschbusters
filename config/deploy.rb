# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# require "whenever/capistrano"

set :application, 'koelschbusters'

set :scm, :git
set :user, 'koelschb'
set :repo_url,  'git@github.com:Uepsilon/koelschbusters.git'
set :deploy_to, '/var/www/virtual/koelschb/rails/koelschbusters/'

set :linked_files, %w(config/database.yml config/secrets.yml)
set :linked_dirs, %w(bin log tmp vendor/bundle public/system public/assets)

set :bundle_path, -> { '~/.gem' }
set :bundle_binstubs, nil

# Suppress all those debug messages
set :log_level, :info

SSHKit.config.command_map[:rake]  = 'bundle exec rake'
SSHKit.config.command_map[:rails] = 'bundle exec rails'

set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Update the crontab file'
  task :update_crontab do
    on roles(:db) do
      execute "cd #{release_path} && whenever --update-crontab #{fetch(:application)}"
    end
  end
end
namespace :symlink do
  desc 'Symlinks shared folder'
  task :pictures do
    on roles(:app) do
      execute "mkdir -p #{current_path.join('shared', 'production')}"
      execute "ln -s #{shared_path.join('pictures')} #{current_path.join('shared', fetch(:rails_env).to_s, 'pictures')}"
      execute "ln -s #{shared_path.join('ckeditor')} #{current_path.join('shared', fetch(:rails_env).to_s, 'ckeditor')}"
    end
  end
end

after :deploy, 'symlink:pictures'
after :deploy, 'deploy:restart'
after :deploy, 'deploy:update_crontab'
after :deploy, 'deploy:cleanup'

set :application, "koelschbusters"

set :scm, :git
set :user, "koelschb"
set :repo_url,  "git@github.com:Uepsilon/koelschbusters.git"
set :deploy_to, "/var/www/virtual/koelschb/rails/koelschbusters/"

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
      # execute "svc -du /home/koelschb/service/nginx"
    end
  end

  after :finishing, "deploy:cleanup"

  namespace :assets do
    task :precompile do
      from = source.next_revision(current_revision)
      if releases.length <= 1 || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        # run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end
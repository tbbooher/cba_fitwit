set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

#require 'mongrel_cluster/recipes'
set :application, "fitwit"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "passenger@sweat:~/fw.git" # "git@github.com:fitwit/FitWit.git"  # Your clone URL
set :scm, "git"
set :branch, "master"

set :deploy_to, "/var/www/#{application}"
set :user, "passenger"

#set :deploy_via, :remote_cache
set :deploy_env, 'production'

# i like to keep sudo away from the passenger user
set :use_sudo, false

# let's save some space!
set :keep_releases, 3 # saves space

# would like to use the actual host-name for these

role :app, "sweat" # fitwit.com ?
role :web, "sweat"
role :db,  "sweat", :primary => true

after "deploy:update_code" do
  run "rvm rvmrc trust #{current_release}"
  #run "touch #{current_release}/log/production.log"
  #run "chmod 0666 #{current_release}/log/production.log"
end

after "deploy:finalize_update", "uploads:symlink"
# let's clean up those old files
after :deploy, "deploy:cleanup"

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

# ==============================
# Uploads
# ==============================

namespace :uploads do

  desc <<-EOD
    [internal] Creates the symlink to uploads shared folder
    for the most recently deployed version.
  EOD
  task :symlink, :except => { :no_release => true } do
    run "rm -rf #{current_path}/public/system"
    run "ln -nfs /var/www/fitwit/shared/system #{current_path}/public/system"
  end

end

## now with bundler
#namespace :bundler do
#  task :create_symlink, :roles => :app do
#    shared_dir = File.join(shared_path, 'bundle')
#    release_dir = File.join(current_release, '.bundle')
#    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
#  end
#
#  task :bundle_new_release, :roles => :app do
#    bundler.create_symlink
#    run "cd #{release_path} && bundle install --without test"
#  end
#end
#
#after 'deploy:update_code', 'bundler:bundle_new_release'

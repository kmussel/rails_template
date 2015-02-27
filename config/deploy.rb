# config valid only for current version of Capistrano
lock '3.3.5'


set :stages, %w(production staging server_app)
set :default_stage, "staging"

# default_run_options[:pty] = true 
# ssh_options[:forward_agent] = true

# set :rvm_string, "ruby-1.9.3-p194"
# set :rvm_type, :system

set :application, "rails_template"
set :repo_url, 'git@github.com:kmussel/rails_template.git'
set :deploy_to, "/home/deploy/rails_template"
set :branch, "master"
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :scm, :git
set :scm_verbose, true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3
set :user, "deploy"

set :bundle_flags, '--quiet'                       # this is default
# after 'deploy:updated',  'deploy:link_tmp'

namespace :deploy do
  # task :start do ; end
  # task :stop do ; end

  # task :restart, :roles => :app, :except => { :no_release => true } do
  #   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  # end

end

namespace :bootstrap do
  task :default do
    root = File.expand_path(File.join(File.dirname(__FILE__), '/../', 'chef/'))
    on roles(:app) do |server|
      # dotest set in ssh config file
      system("cd '#{root}/'; knife solo bootstrap -c .chef/knife.rb dotest nodes/vps.json")      
    end
  end
  task :cook do
    root = File.expand_path(File.join(File.dirname(__FILE__), '/../', 'chef/'))
    on roles(:app) do |server|
      # dotest set in ssh config file
      system("cd '#{root}/'; knife solo cook -c .chef/knife.rb dotest nodes/vps.json")      
    end
  end
end


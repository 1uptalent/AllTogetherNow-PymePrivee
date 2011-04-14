require "bundler/deployment"
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.

set :rvm_ruby_string, 'ruby-1.9.2-p180'

set :application, "production"
set :scm, :git

set :user, "ubuntu"
set :use_sudo, false

set :repository,  "git://github.com/1uptalent/AllTogetherNow-PymePrivee.git"
# Version inicial
# set :branch, "xgn-inicial"
# Versión con RDS
# set :branch, "xgn-rds"
# Última versión en la rama xgn
set :branch, "xgn"

set :deploy_to, "/home/ubuntu/production"

server 'ec2-46-51-147-10.eu-west-1.compute.amazonaws.com', :app, :web, :db, :primary => true
server 'ec2-79-125-36-214.eu-west-1.compute.amazonaws.com', :app, :web, :db


def rake(arguments)
  rake = fetch(:rake, "rake")
  rails_env = fetch(:rails_env, "production")
  run "cd #{current_release}; #{rake} #{arguments} RAILS_ENV=#{rails_env}"
end

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

namespace :db do
  desc 'Create the database'
  task :create do
    rake "db:create"
  end
end

Bundler::Deployment.define_task(self, :task, :except => { :no_release => true })
after "deploy:update_code", "rvm:trust_rvmrc", "bundle:install"
# before "deploy:migrate", "db:create"
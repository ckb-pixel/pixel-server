# frozen_string_literal: true

require "mina/rails"
require "mina/git"
require "mina/bundler"
require "mina/multistage"

# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
require "mina/rvm" # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, "pixel-server"
set :domain, "localhost"
set :deploy_to, "/home/deploy/pixel-server"
set :repository, "https://github.com/ckb-pixel/pixel-server.git"
set :branch, "develop"
set :rails_env, "production"
set :user, "deploy"
# Optional settings:
# set :user, 'foobar'          # Username in the server to SSH to.
# set :port, '30000'           # SSH port number.
# set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

set :shared_dirs, fetch(:shared_dirs, []).push(
  "log",
  "public",
  "vendor"
)

set :shared_files, fetch(:shared_files, []).push(
  "config/database.yml",
  "config/puma.rb",
  "config/master.key",
  "config/credentials/production.key"
)

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
  invoke :'rvm:use', "ruby-2.6.4"
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
  command %[touch "#{fetch(:shared_path)}/config/master.key"]
  command %[touch "#{fetch(:shared_path)}/config/production.key"]
  command %[touch "#{fetch(:shared_path)}/config/pixel-puma.service"]
  command %[touch "#{fetch(:shared_path)}/config/pixel-puma.socket"]
  command %[touch "#{fetch(:shared_path)}/config/pixel-cell-cache.service"]
  comment "Be sure to edit '#{fetch(:shared_path)}/config/database.yml', 'puma.rb', 'pixel-puma.service', 'pixel-puma.socket' and 'pixel-cell-cache.service'."
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    on :launch do
      command "sudo systemctl restart pixel-puma.socket pixel-puma.service"
      command "sudo systemctl restart pixel-cell-cache.service"
      command "sudo systemctl daemon-reload"
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs

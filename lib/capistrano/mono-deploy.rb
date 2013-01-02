require "railsless-deploy"
require "capistrano/mono/server"

Capistrano::Configuration.instance(:must_exist).load do |configuration|

after "deploy:update", "deploy:restart"
after "deploy:rollback", "deploy:restart"

set :application, 'Capistrano-Mono-Deploy' unless defined? application
set :repository, File.dirname(Dir.glob("**/Web.config").first) unless defined? repository
set :scm, :none
set :deploy_via, :copy 	
set :copy_exclude, [".git/*","**/*.cs", "**/_*", "**/*proj", "**/*.user", "**/obj"] unless defined? copy_exclude

set :mono_app, :xsp unless defined? mono

  namespace :deploy do
    task :restart, :roles => :app do
		server = Capistrano::Deploy::MONO.new(mono_app, self)
		server.stop()
		server.start()
    end
	task :start, :roles => :app do
      Capistrano::Deploy::MONO.new(mono_app, self).start();
    end
	task :stop, :roles => :app do
      Capistrano::Deploy::MONO.new(mono_app, self).stop();
    end
  end
  
end


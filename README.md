Capistrano::Mono::Deploy
========================

Capistrano recipe for deploying mono apps.

Features
--------
- Provides `cap deploy` functionality for your mono app
- Automatically starts application using xsp4, fastcgi or using your own custom scripts
- Provides tasks for starting (`cap mono:start`) and stopping (`cap mono:stop`) your mono app

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-mono-deploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-mono-deploy

## Usage

xsp4 capfile example
--------------------
You probably shouldn't use xsp as a production server, consider using nginx with fastcgi

```ruby
require "capistrano/mono-deploy"

role :app, "your.server.fqdn"
set :user, "deploy"
set :deploy_to, "/var/apps/my-app-folder"

```

fastcgi capfile example
-----------------------
This will run fastcgi-mono-server4.exe in the background, if the process dies it will not bring it back up again

```ruby
require "capistrano/mono-deploy"

role :app, "your.server.fqdn"
set :user, "deploy"
set :deploy_to, "/var/apps/my-app-folder"
set :mono_app, :fastcgi

```

Custom command capfile example
------------------------------
```ruby
require "capistrano/mono-deploy"

role :app, "your.server.fqdn"
set :user, "deploy"
set :deploy_to, "/var/apps/my-app-folder"

set :mono_app, :custom
set :custom_stop, "service myMonoApplicaton stop"
set :custom_start, "service myMonoApplicaton start"

```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

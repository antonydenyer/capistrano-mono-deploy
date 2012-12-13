Capistrano::Mono::Deploy
========================

Capistrano recipe for deploying mono apps.

Features
--------
- Provides `cap deploy` functionality for your mono app
- Automatically starts application using xsp4 
- Provides tasks for starting (`cap mono:start`) and stopping (`cap mono:stop`) your mono app

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-mono-deploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-mono-deploy

## Usage

xsp4 Capfile Example
--------------------
You probably shouldn't use xsp as a production server, consider using nginx with fastcgi

```ruby
require "capistrano/mono-deploy"

set :app, "your.server.fqdn"
set :user, "deploy"
set :deploy_to, "/var/apps/my-app-folder"

```

Custom command Capfile Example
------------------------------
```ruby
require "capistrano/mono-deploy"

set :app, "your.server.fqdn"
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

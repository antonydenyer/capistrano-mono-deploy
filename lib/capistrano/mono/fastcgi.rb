require 'capistrano/configuration/actions/invocation'
require 'capistrano/configuration/variables'

module Capistrano
	module Deploy
		module MONO
			class Fastcgi 
				
				def socket
					socketName = @configuration.variables[:application] || "fastcgi-mono-server4"
					socketName = socketName.gsub(/\s+/, "") 
					"/tmp/SOCK-#{socketName}"
        		end

        		def latest_release
        			@configuration.variables[:latest_release]
        		end
				
				def initialize(configuration={})
          			@configuration = configuration
        		end
				def start()
					puts "starting application using fastcgi on socket #{socket}"

					@configuration.run("fastcgi-mono-server4 /applications=/:#{latest_release} /filename=#{socket} /socket=unix > /dev/null 2>&1 &")
					
					attempt_number = 0
					begin
						attempt_number = attempt_number + 1
						@configuration.run("curl localhost --silent --location --header 'Host: #{socket}' --output /dev/null")
					rescue
						sleep 1
						retry if attempt_number < 5
						puts 'You need to configure your web server for fastcgi'
						puts 'For example in nginx it you need to add the following params:'
						puts ''
						puts 'fastcgi_pass unix:/tmp/SOCK-$http_host;'
						puts 'fastcgi_param  PATH_INFO          "";'
						puts 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;'
						puts ''
						raise CommandError.new("Failed to bring up the site")
					end
					puts "The site is up"
				end   

				def stop()
					@configuration.run("pkill fastcgi-mono-server4 > /dev/null 2>&1 &")
				end   				
			end
		end
	end
end
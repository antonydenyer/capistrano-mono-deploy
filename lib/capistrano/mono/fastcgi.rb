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

					appDir = @configuration.capture("readlink -f #{latest_release}").strip

					@configuration.run("fastcgi-mono-server4 /applications=/:#{appDir} /filename=#{socket} /socket=unix > /dev/null 2>&1 &")
					

					attempt_number = 0
					begin
						attempt_number = attempt_number + 1
						status = @configuration.capture("curl --write-out %{http_code} localhost --silent --location --output /dev/null ").strip.to_i
						if(status >= 400)
							puts "localhost responded with #{status}"
							raise
						end
					rescue
						#HACK: you should just add www-data to the user
						@configuration.run("chmod 777 #{socket}")
						sleep 1
						retry if attempt_number < 5
						puts 'You need to configure your web server for fastcgi'
						puts 'For example in nginx it you need to add the following params:'
						puts ''
						puts 'fastcgi_pass unix:/tmp/SOCK-$http_host;'
						puts ''
						puts 'check out http://www.mono-project.com/FastCGI_Nginx for more details'
						raise CommandError.new("Failed to bring up the site")
					end
					puts "The site is up"
				end   

				def stop()
					@configuration.run("pkill mono || true")
				end   				
			end
		end
	end
end
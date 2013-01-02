require 'capistrano/configuration/actions/invocation'
require 'capistrano/configuration/variables'

module Capistrano
	module Deploy
		module MONO
			class Xsp 
				
				def port
          			@configuration.variables[:xsp_port] || 8080
        		end
				
				def command
          			@configuration.variables[:xsp_command] || "xsp4 --nonstop"
        		end
				
				def initialize(configuration={})
          			@configuration = configuration
        		end
				def start()
					puts "starting application using xsp >>> NOT FOR PRODUCTION USE <<< "
					# had a lot of problems getting this to work and returning back to capistrano,
					# the only solution I found was to pipe everything to /dev/null
					# the downside is that you don't get any errors back from xsp
					@configuration.run("#{command} --port #{port} --root #{@configuration.latest_release} > /dev/null 2>&1 &")
					# fails even with --retry ?!?
					attempt_number = 0
					begin
						attempt_number = attempt_number + 1
						status = @configuration.capture("curl --write-out %{http_code} localhost:#{port} --silent --location --output /dev/null ").strip.to_i
						if(status >= 400)
							puts "localhost responded with #{status}"
							raise
						end
					rescue
						sleep 1
						retry if attempt_number < 10
						raise CommandError.new("Failed to bring up the site")
					end
					puts "The site is up"
				end   

				def stop()
					puts "killing mono process >>> NOT FOR PRODUCTION USE <<< "
					@configuration.run("pkill mono > /dev/null 2>&1 &")
				end   				
			end
		end
	end
end
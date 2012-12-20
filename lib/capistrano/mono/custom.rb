require 'capistrano/configuration/actions/invocation'
require 'capistrano/configuration/variables'

module Capistrano
	module Deploy
		module MONO
			class Custom 
				
				def stop_command
					if @configuration.variables.has_key?(:custom_stop)
						return @configuration.variables[:custom_stop]
					end	
					raise Capistrano::Error, "could not find variable custom_stop defined" 					
        		end
				
				def start_command
          			if @configuration.variables.has_key?(:custom_start)
						return @configuration.variables[:custom_start]
					end	
					raise Capistrano::Error, "could not find variable custom_start defined" 	
        		end
				
				def initialize(configuration={})
          			@configuration = configuration
        		end
				def start()
					puts "> starting application using custom command"
					@configuration.run("#{start_command}")
				end   

				def stop()
					puts "> stopping application using custom command"
					@configuration.run("#{stop_command}")
				end   				
			end
		end
	end
end
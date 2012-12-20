require 'capistrano/configuration/actions/invocation'
require 'capistrano/configuration/variables'

module Capistrano
	module Deploy
		module MONO
			class Upstart
				# Ideas taken from https://github.com/loopj/capistrano-node-deploy/blob/master/lib/capistrano/node-deploy.rb

				def generate_upstart_config
					template = '#!upstart ' <<
						'description "{{application}} mono app"' <<
						'author "Antony Denyer" https://github.com/antonydenyer/capistrano-mono-deploy' <<
						'' <<
						'start on (filesystem and net-device-up IFACE=lo)' <<
						'stop on shutdown' <<
						'' <<
						'respawn' <<
						'respawn limit 99 5'<<
						'' <<
						'script' <<
						'{{fastcgi_command}}' <<
						'end script'

  					template.gsub(/\{\{(.*?)\}\}/) { eval($1) }
				end	
	
				def upstart_job_name
					@configuration.variables[:upstart_job_name] || "#{application}"
				end

				def upstart_file_path
					@configuration.variables[:upstart_file_path] || "/etc/init/#{upstart_job_name}.conf"
				end

				def application
					socketName = @configuration.variables[:application] || "upstart-fastcgi-mono-server4"
					socketName = socketName.gsub(/\s+/, "") 
        		end

				def socket
					socketName = @configuration.variables[:application] || "fastcgi-mono-server4"
					socketName = socketName.gsub(/\s+/, "") 
					"/tmp/SOCK-#{socketName}"
        		end

        		def latest_release
        			@configuration.variables[:latest_release]
        		end

        		def fastcgi_command
        			@configuration.variables[:fastcgi_command] || "fastcgi-mono-server4 /applications=/:#{latest_release} /filename=#{socket} /socket=unix > /dev/null 2>&1 &"
        		end


				def remote_file_exists?(full_path)
				  'true' == @configuration.capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
				end

				def remote_file_content_same_as?(full_path, content)
				  Digest::MD5.hexdigest(content) == capture("md5sum #{full_path} | awk '{ print $1 }'").strip
				end

				def remote_file_differs?(full_path, content)
				  exists = remote_file_exists?(full_path)
				  !exists || exists && !remote_file_content_same_as?(full_path, content)
				end

				def create_upstart_config
      				config_file_path = "/etc/init/#{application}.conf"
      				temp_config_file_path = "/tmp/#{application}.conf"
      				# Generate and upload the upstart script
      				@configuration.put generate_upstart_config, temp_config_file_path
				     # Copy the script into place and make executable
      				@configuration.sudo("cp #{temp_config_file_path} #{upstart_file_path}")
    			end
				
				def initialize(configuration={})
          			@configuration = configuration
        		end

        		def sudo
        			@configuration.variables[:sudo]
        		end
				def start()
					create_upstart_config if remote_file_differs?(upstart_file_path, generate_upstart_config)
					puts "starting application using fastcgi on socket #{socket}"

					@configuration.run("")
					
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

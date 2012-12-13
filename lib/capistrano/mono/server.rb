module Capistrano
  module Deploy
    module MONO
      def self.new(mono, config={})
        mono_file = "capistrano/mono/#{mono}.rb"
        require(mono_file)

        mono_const = mono.to_s.capitalize.gsub(/_(.)/) { $1.upcase }
        if const_defined?(mono_const)
          const_get(mono_const).new(config)
        else
          raise Capistrano::Error, "could not find '#{name}::#{mono_const}' in '#{mono_file}'"
        end
      rescue LoadError
        raise Capistrano::Error, "could not find any MONO deploy strategy named `#{mono}'"
      end
    end
  end
end

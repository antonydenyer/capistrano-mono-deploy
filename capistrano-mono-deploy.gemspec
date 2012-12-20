# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
gem.name          = "capistrano-mono-deploy"
gem.version       = "0.1.3"
gem.authors       = ["Antony Denyer"]
gem.email         = ["antonydenyer@gmail.com"]
gem.description   = %q{some capistrano recipes for deploying mono apps on to linux servers, currently only supports xsp}
gem.summary       = %q{Deploy mono applications with capistrano}
gem.homepage      = "https://github.com/antonydenyer/capistrano-mono-deploy"

gem.files = `git ls-files`.split("\n") 
gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
gem.require_paths = ["lib"]
end

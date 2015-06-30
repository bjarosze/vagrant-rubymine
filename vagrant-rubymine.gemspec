# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant/rubymine/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-rubymine'
  spec.version       = Vagrant::Rubymine::VERSION
  spec.authors       = ['bjarosze']
  spec.email         = ['b.jarosze@gmail.com']
  spec.summary       = 'Vagrant plugin that creates environment variables with paths to Rubymine projects on guest machine.'
  spec.description   = 'Creates environment variables with paths to Rubymine projects.'
  spec.homepage      = 'https://github.com/bjarosze/vagrant-rubymine'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end

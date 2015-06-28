# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant/rubymine/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-rubymine'
  spec.version       = Vagrant::Rubymine::VERSION
  spec.authors       = ['Bartosz Jaroszewski']
  spec.email         = ['b.jarosze@gmail.com']
  spec.summary       = 'Creates guest environment variables with paths to projects.'
  spec.description   = 'Creates guest environment variables with paths to projects.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end

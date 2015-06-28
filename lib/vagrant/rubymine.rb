require 'bundler'

begin
  require 'vagrant'
rescue LoadError
  Bundler.require(:default, :development)
end

require 'vagrant/rubymine/plugin'
require 'vagrant/rubymine/command'
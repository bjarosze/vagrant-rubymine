module Vagrant
  module Rubymine
    class Plugin < Vagrant.plugin('2')
      name 'rubymine-env'

      description <<-DESC
        Creates environment variables with paths to Rubymine projects.
      DESC

      config(:rubymine) do
        require_relative 'config'
        Config
      end

      action_hook(:set_host_path_on_up, :machine_action_up) do |hook|
        require_relative 'middleware'
        hook.append(Middleware)
      end

      action_hook(:set_host_path_on_up, :machine_action_reload) do |hook|
        require_relative 'middleware'
        hook.append(Middleware)
      end

    end
  end
end

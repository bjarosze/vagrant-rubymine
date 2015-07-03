require_relative 'rubymine_conf'
require_relative 'bash_profile'

module Vagrant
  module Rubymine
    class Middleware

      PROFILE_PATH = '/etc/profile.d/vagrant-rubymine.sh'

      def initialize(app, env)
        @app = app
      end

      def call(env)
        @machine = env[:machine]
        setup
        @app.call(env)
      end

      protected

      def sudo(command)
        @machine.communicate.sudo(command)
      end

      def config
        @machine.config.rubymine
      end

      def setup
        bash_profile = BashProfile.new(PROFILE_PATH)
        bash_profile.create_profile

        export_commands.each do |command|
          bash_profile.add_command(command)
        end

        bash_profile.apply do |command|
          sudo(command)
        end

        @machine.ui.success('Rubymine paths set!')
      end

      def export_commands
        rubymine_conf = RubymineConf.new(config.config_path)
        gems_paths = rubymine_conf.gems_paths
        projects_paths = rubymine_conf.projects_paths

        commands = []

        gems_paths.each do |project_name, gems_path|
          commands << "export #{project_name}_path=\"#{projects_paths[project_name]}\""
          commands << "export #{project_name}_gems_path=\"#{gems_path}\""
        end

        commands
      end
    end
  end

end

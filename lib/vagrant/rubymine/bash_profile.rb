require 'find'
require 'nokogiri'

module Vagrant
  module Rubymine
    class BashProfile

      def initialize(profile_path)
        @profile_path = profile_path
        @commands = []
        create_profile
      end

      def add_command(command)
        @commands << "echo \"#{escape_shell(command)}\" >> \"#{@profile_path}\""
      end

      def execute(&block)
        @commands.each do |command|
          block.call(command)
        end
      end

      private

      def create_profile
        @commands << "rm -f #{@profile_path}"
        @commands << "touch #{@profile_path}"
      end

      def escape_shell(content)
        content.gsub(/["`\\]/, '\\\\\0')
      end

    end
  end
end

module Vagrant
  module Rubymine
    class BashProfile

      def initialize(profile_path)
        @profile_path = profile_path
        @commands = []
      end

      def add_command(command)
        @commands << "echo \"#{escape_shell(command)}\" >> \"#{@profile_path}\""
      end

      def apply(&block)
        @commands.each do |command|
          block.call(command)
        end
      end

      def create_profile
        @commands << "rm -f #{@profile_path}"
        @commands << "touch #{@profile_path}"
      end

      private

      def escape_shell(content)
        content.gsub(/["`\\]/, '\\\\\0')
      end

    end
  end
end

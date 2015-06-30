module Vagrant
  module Rubymine
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :config_path

      def initialize
        @config_path = UNSET_VALUE
      end

      def finalize!
        @config_path = nil if @config_path == UNSET_VALUE
      end
    end
  end
end

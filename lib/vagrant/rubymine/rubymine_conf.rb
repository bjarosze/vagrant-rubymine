require 'find'
require 'nokogiri'

module Vagrant
  module Rubymine

    class Error < StandardError; end
    class ConfigNotFound < Error; end

    class RubymineConf

      GEM_MANAGER_PATH = '/config/options/gemmanager.xml'
      OTHER_PATH = '/config/options/other.xml'

      def initialize(root_path=nil)
        @root_path = root_path || detect_root_path
        raise ConfigNotFound, "#{config_gem_manager_path} or #{config_other_path}" if !valid?
      end

      def valid?
        @root_path && File.exists?(config_gem_manager_path) && File.exists?(config_other_path)
      end

      def projects_paths
        conf = parse(config_other_path)
        conf.xpath("/application/component[@name='RecentDirectoryProjectsManager']/option[@name='recentPaths']/list/option").inject({}) do |result, option|
          project_path = option.xpath('@value').map(&:value).first
          project_name = project_path.split('\\').last
          result[normalize_project_name(project_name)] = project_path
          result
        end
      end

      def gems_paths
        conf = parse(config_gem_manager_path)
        conf.xpath('/application/component/sdk2gems').inject({}) do |result, sdk|
          sdk_name = (sdk_attr = sdk.xpath('@sdk')).empty? ? nil : sdk_attr.first.value
          if (match = sdk_name.match(/\[(.*)\]/))
            project_name = match[1]
            url_attr = sdk.xpath('box[1]/@url')
            if (gems_path = url_attr.first.value)
              gems_path = gems_path.gsub('file://$USER_HOME$', ENV['USERPROFILE']).gsub('/', '\\').downcase
              result[normalize_project_name(project_name)] = gems_path
            end
          end
          result
        end
      end

      private

      def normalize_project_name(project_name)
        project_name.gsub('-', '_')
      end

      def config_gem_manager_path
        @root_path + GEM_MANAGER_PATH
      end

      def config_other_path
        @root_path + OTHER_PATH
      end

      def parse(file_path)
        file = File.open(file_path)
        Nokogiri::XML(file)
      ensure
        file.close
      end

      def detect_root_path
        search_path = ENV['USERPROFILE']
        Find.find(search_path) do |path|
          if path =~ /.RubyMine/i
            return "#{path}"
          end
        end
      end


    end
  end
end
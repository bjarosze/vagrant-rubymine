require 'test/unit'
require 'vagrant/rubymine/rubymine_conf'

class RubymineConfTest < Test::Unit::TestCase
  TEST_CONFIG_PATH = 'test'

  def setup
    @rubymine_conf = ::Vagrant::Rubymine::RubymineConf.new
    ENV['USERPROFILE'] = TEST_CONFIG_PATH
  end

  def test_incorrect_config_path
    assert_raise ::Vagrant::Rubymine::ConfigNotFound do
      ::Vagrant::Rubymine::RubymineConf.new('fake')
    end
  end

  def test_detecting_file
    config_path = ::Vagrant::Rubymine::RubymineConf.new.instance_variable_get('@root_path')
    assert Dir.exists?(config_path)
  end

  def test_parsing
    file_path = 'test/.test_rubymine_config_dir/config/options/other.xml'
    assert @rubymine_conf.send(:parse, file_path).kind_of?(Nokogiri::XML::Document)
  end

  def test_validation
    assert @rubymine_conf.valid?
  end

  def test_getting_gems_paths
    gems_paths = @rubymine_conf.gems_paths
    assert_equal "#{ENV['USERPROFILE']}\\.rubymine70\\system\\ruby_stubs\\-1898370286\\-1715081484\\gems", gems_paths['merca']
  end

  def test_getting_project_paths
    project_paths = @rubymine_conf.projects_paths
    assert_equal 'C:\\Users\\Bartosz\\Development\\workspace\\merca', project_paths['merca']
  end

  def test_normalization_of_project_name
    normalized_project_name = @rubymine_conf.send(:normalize_project_name, 'test-project')
    assert_equal 'test_project', normalized_project_name
  end
end
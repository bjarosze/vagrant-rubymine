require 'test/unit'
require 'vagrant/rubymine/bash_profile'

class BashProfileTest < Test::Unit::TestCase

  BASH_PROFILE_PATH = '.bash_profile'

  def setup
    @bash_profile = ::Vagrant::Rubymine::BashProfile.new(BASH_PROFILE_PATH)
  end

  def test_creating_profile
    @bash_profile.create_profile
    commands = @bash_profile.instance_variable_get('@commands')

    assert_equal ['rm -f .bash_profile', 'touch .bash_profile'], commands
  end

  def test_adding_and_applying_commands
    @bash_profile.add_command('test_command1')
    @bash_profile.add_command('test_command2')

    commands = []
    @bash_profile.apply  do |command|
      commands << command
    end

    assert_equal ['echo "test_command1" >> ".bash_profile"', 'echo "test_command2" >> ".bash_profile"'], commands
  end

  def test_escaping_shell
    escaped = @bash_profile.send(:escape_shell, 'test"`\\')

    assert_equal 'test\\"\\`\\\\', escaped
  end

end

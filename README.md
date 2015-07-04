# Vagrant Rubymine

This plugin creates an environment variables on guest machine with paths to your Rubymine projects and its gems directory on host machine. Paths are read from Rubymine configuration.

Variables naming convention (e.g. for project named "sample"):
```
sample_path        # path to your project
sample_gems_path   # path to your project's gems
```

## Requirments

This is first version tested on Rubymine 7.0.4 and Vagrant 1.7.2. If you need support for other version you can submit an issue.

## Installation

Execute:
```
$ vagrant plugin install vagrant-rubymine
```

## Usage

After login on your guest machine you can use variables with your projects' paths, e.g:
```
$ echo $sample_path
$ echo $sample_gems_dir
```

You can use it to configure [charliesome/better_errors] (https://github.com/charliesome/better_errors):
```ruby
# initializers/better_errors.rb

if defined? BetterErrors
  # Opening files
  BetterErrors.editor = proc do |full_path, line|
    project_name = Rails.root.to_s.split('/').last.downcase
    project_path = ENV["#{project_name}_path"]
    gems_path = ENV["#{project_name}_gems_path"]

    if project_path && full_path =~ /#{Rails.root.to_s}/
      full_path = full_path.sub(Rails.root.to_s, project_path).sub('/', '\\')
    elsif gems_path && full_path =~ /#{Gem.dir}/
      full_path = full_path.sub("#{Gem.dir}/gems", gems_path).sub('/', '\\')
    end

    "runapp://rubymine?project_path=#{project_path}&line=#{line}&file_path=#{full_path}"
  end

  # Allowing host
  host = ENV["SSH_CLIENT"] ? ENV["SSH_CLIENT"].match(/\A([^\s]*)/)[1] : nil
  BetterErrors::Middleware.allow_ip! host if [:development, :test].member?(Rails.env.to_sym) && host
end

```


## Contributing

1. Fork it ( https://github.com/bjarosze/vagrant-rubymine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

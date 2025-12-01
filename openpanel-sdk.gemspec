# frozen_string_literal: true

require_relative 'lib/openpanel/sdk/version'

Gem::Specification.new do |spec|
  spec.name = 'openpanel-sdk'
  spec.version = OpenPanel::SDK::VERSION
  spec.authors = ['Thomas Stätter']
  spec.email = ['Thomas Stätter <thomas.staetter@gmail.com>']

  spec.summary = 'OpenPanel SDK for Ruby'
  spec.description = 'OpenPanel SDK for Ruby'
  spec.homepage = 'https://github.com/tstaetter/openpanel-sdk'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tstaetter/openpanel-sdk'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/])
    end
  end
  # spec.bindir = 'exe'
  # spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Use Faraday for HTTP requests [https://lostisland.github.io/faraday/]
  spec.add_dependency 'faraday'
  spec.add_development_dependency 'rspec', '~> 3.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

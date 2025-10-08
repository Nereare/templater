# frozen_string_literal: true

require_relative 'lib/repo_templater/meta'

Gem::Specification.new do |spec|
  spec.name        = RepoTemplater::SLUG
  spec.version     = RepoTemplater::VERSION
  spec.license     = RepoTemplater::LICENSE
  spec.author      = RepoTemplater::AUTHOR
  spec.email       = RepoTemplater::AUTHOR_EMAIL
  spec.summary     = RepoTemplater::DESCRIPTION
  spec.homepage    = 'https://github.com/Nereare/templater'

  spec.required_ruby_version = '~> 3.2'

  spec.metadata['source_code_uri']   = spec.homepage
  spec.metadata['bug_tracker_uri']   = 'https://github.com/Nereare/templater/issues'
  spec.metadata['changelog_uri']     = 'https://github.com/Nereare/templater/blob/master/CHANGELOG.md'
  # TODO: spec.metadata['documentation_uri'] = ''

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.bindir        = 'bin'
  spec.executables   = 'repo_templater'
  spec.require_paths = ['lib']

  spec.add_dependency 'irb', '~> 1.15', '>= 1.15.2'
  spec.add_dependency 'pastel', '~> 0.8'
  spec.add_dependency 'tty-exit', '~> 0.1'
  spec.add_dependency 'tty-option', '~> 0.3'
  spec.add_dependency 'tty-prompt', '~> 0.23'

  spec.add_development_dependency 'rake', '~> 13.3'
  spec.add_development_dependency 'rdoc', '~> 6.15'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.81', '>= 1.81.1'
  spec.add_development_dependency 'rubocop-rake', '~> 0.7.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 3.7'
end

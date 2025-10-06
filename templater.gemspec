# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'templater'
  spec.version     = '0.1.0'
  spec.license     = 'WTFPL'
  spec.author      = 'Igor Padoim'
  spec.email       = 'igorpadoim@gmail.com'
  spec.summary     = 'An advancement of the previous template repository.'
  spec.homepage    = 'https://github.com/Nereare/templater'

  spec.required_ruby_version = '~> 3.2'

  spec.metadata['homepage_uri']      = spec.homepage
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
  spec.executables   = 'templater'
  spec.require_paths = ['lib']

  spec.add_dependency 'irb', '~> 1.15', '>= 1.15.2'
  spec.add_dependency 'tty-prompt', '~> 0.23'

  spec.add_development_dependency 'rake', '~> 13.3'
  spec.add_development_dependency 'rspec', '~> 3.13'
end

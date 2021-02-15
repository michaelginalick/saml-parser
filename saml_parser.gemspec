# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'saml_parser/version'

Gem::Specification.new do |s|
  s.name        = 'saml_parser'
  s.version     = '0.1.0'
  s.summary     = 'A library to parse XML documents for SAML configuration'
  s.description = 'A simple library to parse out essential elements for SAML configuration'
  s.authors     = ['Michael Ginalick']
  s.email       = 'michael.ginalick@gmail.com'
  s.homepage    =
    'https://rubygems.org/gems/saml_parser'
  s.license = 'MIT'
  s.files = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^spec/}) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.3'

  # Only essential development tools and dependencies go here.
  # Other non-essential development dependencies go in the Gemfile.
  s.add_development_dependency 'rspec', '~> 3.8'
  # 0.81 is the last rubocop version with Ruby 2.3 support
  s.add_development_dependency 'rubocop', '0.81.0'
  s.add_development_dependency 'rubocop-rspec', '1.38.1'
end

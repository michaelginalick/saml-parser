# frozen_string_literal: true

source 'https://rubygems.org'

gemspec
not_jruby = %i[ruby mingw x64_mingw].freeze

gem 'bundler', '>= 1.17', '< 3'
gem 'byebug', platforms: not_jruby
gem 'irb', '~> 1.0'
gem 'openssl'
gem 'rspec_junit_formatter', '~> 0.4'
gem 'simplecov-cobertura', require: false
gem 'simplecov', '>= 0.17.1'
# for server side request forgery (ssrf) attacks via URLs
gem 'ssrf_filter', '~> 1.0'
# Any nokogiri earlier than 1.8.1 has a security vulnerability
gem 'nokogiri', '>= 1.8.1'
gem 'yard', '~> 0.9.25', platforms: not_jruby

# frozen_string_literal: true

source 'https://rubygems.org'

def eval_version(dependency, version)
  return [dependency] if version.empty?

  version.count('.') < 2 ? [dependency, "~> #{version}.0"] : [dependency, version]
end

if ENV['DEVEL'] == '1'
  gem 'administrate_ransack', path: './'
else
  gemspec
end

ruby_ver = ENV.fetch('RUBY_VERSION', '')

rails_ver = ENV.fetch('RAILS_VERSION', '')
rails = eval_version('rails', rails_ver)
gem(*rails)

ransack_ver = ENV.fetch('RANSACK_VERSION', '')
ransack = eval_version('ransack', ransack_ver)
gem(*ransack)

administrate_ver = ENV.fetch('ADMINISTRATE_VERSION', '')
administrate = eval_version('administrate', administrate_ver)
gem(*administrate)

ruby32 = ruby_ver.empty? || Gem::Version.new(ruby_ver) >= Gem::Version.new('3.2')
rails72 = rails_ver.empty? || Gem::Version.new(rails_ver) >= Gem::Version.new('7.2')
sqlite3 = ruby32 && rails72 ? ['sqlite3'] : ['sqlite3', '~> 1.4']
gem(*sqlite3)

gem 'zeitwerk', '~> 2.6.18' unless ruby32

# NOTE: to avoid error: uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger
gem 'concurrent-ruby', '1.3.4'

# Misc
gem 'bigdecimal'
gem 'csv'
gem 'mutex_m'
gem 'puma'
gem 'sassc'
gem 'sprockets-rails'

# Testing
gem 'capybara'
gem 'cuprite'
gem 'rails-controller-testing'
gem 'rspec_junit_formatter'
gem 'rspec-rails'
gem 'simplecov', require: false
gem 'super_diff'

# Linters
gem 'fasterer'
gem 'rubocop'
gem 'rubocop-capybara'
gem 'rubocop-packaging'
gem 'rubocop-performance'
gem 'rubocop-rails'
gem 'rubocop-rspec'
gem 'rubocop-rspec_rails'

# Tools
gem 'pry-rails'

# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)

require 'administrate_ransack/version'

Gem::Specification.new do |spec|
  spec.name        = 'administrate_ransack'
  spec.version     = AdministrateRansack::VERSION
  spec.authors     = ['Mattia Roccoberton']
  spec.email       = ['mat@blocknot.es']
  spec.homepage    = 'https://github.com/blocknotes/administrate_ransack'
  spec.summary     = 'Administrate Ransack plugin'
  spec.description = 'A plugin for Administrate to use Ransack for search filters'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_runtime_dependency 'administrate', '~> 0.18'
  spec.add_runtime_dependency 'ransack', '>= 2.3', '< 5'
end

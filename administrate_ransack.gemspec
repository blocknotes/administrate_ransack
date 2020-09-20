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
  spec.description = 'A plugin for Administrate to use Ransack for filtering resources'
  spec.license     = 'MIT'

  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'administrate', '~> 0.14.0'
  spec.add_dependency 'ransack', '~> 2.3.2'

  spec.add_development_dependency 'rubocop', '~> 0.90'
end

# frozen_string_literal: true

require 'spec_helper'

ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start 'rails'

require File.expand_path('dummy/config/environment.rb', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'capybara/rails'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

# Force deprecations to raise an exception.

if Rails.gem_version < Gem::Version.new("7.1")
  ActiveSupport::Deprecation.behavior = :raise
else
  Rails.application.deprecators.behavior = :raise
end

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Spec helper methods
module SpecHelpers
  class << self
    def setup_data
      Rails.application.load_seed
      author = Author.find_by!(name: 'A test author')
      tag = Tag.find_by!(name: 'A test tag')
      Post.first.update!(title: 'A post', author: author, category: 'news', published: true, dt: Time.zone.today)
      Post.second.update!(title: 'Another post', author: author, category: 'story', dt: Date.yesterday, tags: [tag])
      Post.third.update!(title: 'Last post', author: author, category: 'news', position: 234, dt: Date.tomorrow)
    end
  end
end

RSpec.configure do |config|
  if Rails.gem_version < Gem::Version.new("7.1")
    config.fixture_path = Rails.root.join('spec/fixtures').to_s
  else
    config.fixture_paths = [Rails.root.join('spec/fixtures').to_s]
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.render_views = false

  config.before(:suite) do
    SpecHelpers.setup_data
  end

  config.before(:suite) do
    require 'administrate/version'

    intro = ('-' * 80)
    intro << "\n"
    intro << "- Ruby:         #{RUBY_VERSION}\n"
    intro << "- Rails:        #{Rails.version}\n"
    intro << "- Administrate: #{Administrate::VERSION}\n"
    intro << ('-' * 80)

    RSpec.configuration.reporter.message(intro)
  end
end

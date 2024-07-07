# frozen_string_literal: true

RSpec.configure do |config|
  config.prepend_before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome
  end
end

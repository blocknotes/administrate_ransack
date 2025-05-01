# frozen_string_literal: true

require "ransack/version"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :published, -> {}

  class << self
    if Gem::Version.new(Ransack::VERSION) >= Gem::Version.new("4.0.0")
      def ransackable_attributes(auth_object = nil)
        authorizable_ransackable_attributes
      end

      def ransackable_associations(auth_object = nil)
        authorizable_ransackable_associations
      end
    end
  end
end

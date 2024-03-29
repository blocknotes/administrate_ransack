# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :published_posts, -> { published }, class_name: 'Post'
  has_many :recent_posts, -> { recents }, class_name: 'Post'
  has_many :tags, through: :posts
  has_many :pictures, as: :imageable

  has_one :profile, inverse_of: :author, dependent: :destroy

  accepts_nested_attributes_for :profile, allow_destroy: true

  validates :email, format: { with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/i, message: 'Invalid email' }

  validate -> {
    errors.add( :base, 'Invalid age' ) if !age || age.to_i % 3 == 1
  }

  def to_s
    name
  end
end

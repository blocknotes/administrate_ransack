# frozen_string_literal: true

class Post < ApplicationRecord
  enum category: { 'news' => 'news', 'story' => 'story', 'gallery' => 'gallery' }

  belongs_to :author, inverse_of: :posts, autosave: true

  has_one :author_profile, through: :author, source: :profile

  has_many :post_tags, inverse_of: :post, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :pictures, as: :imageable

  validates :title, allow_blank: false, presence: true

  scope :published, -> { where(published: true) }
  scope :recents, -> { where('created_at > ?', 1.month.ago).order(created_at: :desc) }

  def to_s
    title
  end

  def short_title
    title.truncate 10
  end

  def upper_title
    title.upcase
  end
end

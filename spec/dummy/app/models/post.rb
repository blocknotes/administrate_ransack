# frozen_string_literal: true

class Post < ApplicationRecord
  enum :category, { 'news' => 'news', 'story' => 'story', 'gallery' => 'gallery' }

  belongs_to :author, inverse_of: :posts, autosave: true

  has_one :author_profile, through: :author, source: :profile

  has_many :post_tags, inverse_of: :post, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :pictures, as: :imageable

  validates :title, allow_blank: false, presence: true

  scope :recents, ->(dt = 1.month.ago) { where('dt > ?', dt).order(dt: :desc) }
  scope :by_category, ->(category) { where(category: category) }

  def to_s
    title
  end

  def short_title
    title.truncate 10
  end

  def upper_title
    title.upcase
  end

  class << self
    def ransackable_scopes(_auth_object = nil)
      %i[by_category recents]
    end
  end
end

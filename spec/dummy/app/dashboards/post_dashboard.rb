require "administrate/base_dashboard"

class PostDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    author: Field::BelongsTo,
    pictures: Field::HasMany,
    # author_profile: Field::HasOne,
    # post_tags: Field::HasMany,
    tags: Field::HasMany,
    id: Field::Number,
    title: Field::String,
    description: Field::Text,
    category: Field::Select.with_options(collection: Post.categories),
    dt: Field::Date,
    position: Field::Number.with_options(decimals: 2),
    published: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    author
    title
    published
    dt
    category
    created_at
  ].freeze
  # author_profile
  # post_tags
  # created_at

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    author
    tags
    id
    title
    description
    category
    dt
    position
    published
    created_at
    updated_at
    pictures
  ].freeze
  # author_profile
  # post_tags

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    author
    tags
    title
    description
    category
    dt
    position
    published
    pictures
  ].freeze
  # author_profile
  # post_tags

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {
    published: ->(resources) { resources.published },
    recents: ->(resources) { resources.recents }
  }.freeze

  # Overwrite this method to customize how posts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(post)
  #   "Post ##{post.id}"
  # end
end

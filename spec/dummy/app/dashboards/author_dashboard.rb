require "administrate/base_dashboard"

class AuthorDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    posts: Field::HasMany,
    pictures: Field::HasMany,
    # published_posts: Field::HasMany.with_options(class_name: "Post"),
    # recent_posts: Field::HasMany.with_options(class_name: "Post"),
    # tags: Field::HasMany,
    profile: Field::HasOne,
    # avatar_attachment: Field::HasOne,
    # avatar_blob: Field::HasOne,
    id: Field::Number,
    name: Field::String,
    age: Field::Number,
    email: Field::Email,
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
    name
    email
    posts
  ].freeze
  # tags
  # published_posts
  # recent_posts

  # RANSACK_TYPES
  RANSACK_TYPES = {
    posts: Field::HasMany,
    tags: Field::HasMany,
    name: Field::String,
    name_or_email_cont: Field::String,
    name_not_cont: Field::String,
    age: Field::Number
  }.freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    age
    email
    created_at
    updated_at
    profile
    posts
    pictures
  ].freeze
  # tags
  # published_posts
  # recent_posts
  # avatar_attachment
  # avatar_blob

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    age
    email
    profile
    posts
    pictures
  ].freeze
  # tags
  # published_posts
  # recent_posts
  # avatar_attachment
  # avatar_blob

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
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how authors are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(author)
    author.name
  end
end

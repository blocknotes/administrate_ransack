# Administrate Ransack
[![gem version](https://badge.fury.io/rb/administrate_ransack.svg)](https://badge.fury.io/rb/administrate_ransack)
[![gem downloads](https://badgen.net/rubygems/dt/administrate_ransack)](https://rubygems.org/gems/administrate_ransack)
[![linters](https://github.com/blocknotes/administrate_ransack/actions/workflows/linters.yml/badge.svg)](https://github.com/blocknotes/administrate_ransack/actions/workflows/linters.yml)
[![Specs Rails 8.0](https://github.com/blocknotes/administrate_ransack/actions/workflows/specs_rails80.yml/badge.svg)](https://github.com/blocknotes/administrate_ransack/actions/workflows/specs_rails80.yml)

A plugin for [Administrate](https://github.com/thoughtbot/administrate) to use [Ransack](https://github.com/activerecord-hackery/ransack) for filtering resources.

Features:
- add Ransack search results using module prepend inside an Administrate controller;
- offer a filters partial based on the resource's attributes;
- customize searchable attributes.

## Installation

- After installing Administrate, add to *Gemfile*: `gem 'administrate_ransack'` (and execute `bundle`)
- Edit your admin resource controller adding inside the class body:

```rb
prepend AdministrateRansack::Searchable
```

- Add to your resource index view (ex. to generate the index for a Post model: `bin/rails generate administrate:views:index Post`):

```erb
<%= render('administrate_ransack/filters') %>
```

- Update your model (ex. Post) exposing the ransackable attributes and associations, skipping this step will raise an exception that explains in details:

```rb
class Post < ApplicationRecord
  # ...

  class << self
    def ransackable_attributes(_auth_object = nil)
      %w[title description]
    end

    def ransackable_associations(_auth_object = nil)
      %w[author]
    end
  end
end
```

- See the Usage section for extra options

## Usage

- The filters partial accepts some optional parameters:
  + `attribute_labels`: hash used to override the field labels, ex. `{ title: "The title" }`
  + `attribute_types`: hash used to specify the filter fields, ex. `{ title: Administrate::Field::String }`
  + `search_path`: the path to use for searching (form URL)
  + `namespace`: the namespace used by Administrate, ex. `:supervisor`
- For associations (_has many_/_belongs to_) the label used can be customized adding an `admin_label` method to the target model which returns a string while the collection can by filtered with `admin_scope`. Example:

```rb
# Sample post model
class Post < ApplicationRecord
  scope :admin_scope, -> { where(published: true) }

  def admin_label
    title.upcase
  end
end
```

- For _has_many_ associations it is possible to use Selectize in place of the checkboxes using:

```erb
<!-- Set options for an association named: tags -->
<%= render('administrate_ransack/filters', options: { tags: 'select' } ) %>
```

- To use scopes in filters it's needed to update also the `ransackable_scopes` in the model, example:

```rb
# Sample post model
class Post < ApplicationRecord
  scope :recents, ->(dt = 1.month.ago) { where('dt > ?', dt).order(dt: :desc) }
  scope :by_category, ->(category) { where(category: category) }

  class << self
    def ransackable_scopes(_auth_object = nil)
      %i[by_category recents]
    end
  end
end
```

```erb
<!-- Sample index view -->
<%= render(
  'administrate_ransack/filters',
  attribute_types: { recents: Administrate::Field::DateTime, by_category: Administrate::Field::String }
) %>
```

## Notes

- Administrate Search logic works independently from Ransack searches, I suggest to disable it eventually (ex. overriding `show_search_bar?` in the controller or removing the bar from the view)
- Date/time filters use Rails `datetime_field` method which produces a `datetime-local` input field, at the moment this type of element is not broadly supported, a workaround is to include [flatpickr](https://github.com/flatpickr/flatpickr) datetime library.
  + This gem checks if `flatpickr` function is available in the global scope and applies it to the `datetime-local` filter inputs;
  + you can include the library using your application assets or via CDN, ex. adding to **app/views/layouts/admin/application.html.erb**:

```html
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr@4.5.7/dist/flatpickr.min.css">
  <script src="https://cdn.jsdelivr.net/npm/flatpickr@4.5.7/dist/flatpickr.min.js"></script>

  <script>
    // optionally change the flatpikr options:
    window.flatpickr_filters_options = { dateFormat: "Y-m-d" };
  </script>
```

## Customizations

- Ransack options can be customized defining a `ransack_options` method in the controller, example:

```rb
module Admin
  class PostsController < Admin::ApplicationController
    prepend AdministrateRansack::Searchable

    def ransack_options
      # raises an exception on unknown parameters
      { ignore_unknown_conditions: false }
    end
  end
end
```

- Sample call of the filters partial with different options provided:

```erb
<%
# In alternative prepare an hash in the dashboard like RANSACK_TYPES = {}
attribute_types = {
  title: Administrate::Field::String,
  author: Administrate::Field::BelongsTo,
  category: Administrate::Field::Select.with_options(collection: Post.categories.to_a),
  published: Administrate::Field::Boolean
}
attribute_labels = {
  author: 'Written by',
  title: nil
}
%>
<%= render(
  'administrate_ransack/filters',
  attribute_types: attribute_types,
  attribute_labels: attribute_labels,
  search_path: admin_root_path
) %>
```

- Another option is to prepare some hashes constants in the dashboard (ex. `RANSACK_TYPES`):

```erb
<%= render('administrate_ransack/filters', attribute_types: @dashboard.class::RANSACK_TYPES) %>
```

## Sample styles

- Some basic style to setup the filters as a sidebar (see the screenshot below):

```css
.main-content__body {
  display: inline-block;
  width: calc(100% - 320px);
  vertical-align: top;
}

[data-administrate-ransack-filters] {
  display: inline-block;
  padding-left: 10px;
  padding-top: 10px;
  width: 300px;
}

[data-administrate-ransack-filters] .filter {
  margin-bottom: 10px;
}

[data-administrate-ransack-filters] .filters-buttons {
  margin-top: 30px;
}
```

Screenshot:
![screenshot](extra/screenshot.png)

- Alternative styles for an horizontal search bar:

```css
[data-administrate-ransack-filters] {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: center;
}

[data-administrate-ransack-filters] .filters {
  display: inline-block;
}

[data-administrate-ransack-filters] .filter, [data-administrate-ransack-filters] .filter > label {
  display: inline-block;
}

[data-administrate-ransack-filters] .filter > input {
  display: inline-block;
  width: auto;
}

[data-administrate-ransack-filters] .filters-buttons {
  display: inline-block;
  margin-left: 20px;
}
```

Screenshot:
![screenshot2](extra/screenshot2.png)

## Extra notes

- If you need to define custom search logics you can skip prepending the module (`AdministrateRansack::Searchable`) and create your own search query in a controller (but you need to assign the Ransack search object to `@ransack_results` for the filters partial), for example:

```rb
  def scoped_resource
    @ransack_results = super.ransack(params[:q])
    @ransack_results.result(distinct: true)
  end
```

- Sometimes it's easier to create a new Ransack field than overriding the search logic (there are a lot of good examples in the [Ransack Wiki](https://github.com/activerecord-hackery/ransack/wiki/Using-Ransackers)), example to search in a `jsonb` field adding to a Post model:

```rb
  ransacker :keywords do
    Arel.sql("posts.metadata ->> 'keywords'")
  end
```

- With Administrate Ransack you can easily create links to other resources applying some filters, example to add in a tag show page the link to the related posts:

```erb
  <%= link_to("Tag's posts", admin_posts_path('q[tags_id_in][]': page.resource.id), class: "button") %>
```

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

Or consider offering me a coffee, it's a small thing but it is greatly appreciated: [about me](https://www.blocknot.es/about-me).

## Contributors

- [Mattia Roccoberton](https://blocknot.es/): author
- The good guys that opened issues and pull requests from time to time

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

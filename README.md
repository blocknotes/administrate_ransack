# Administrate Ransack [![Gem Version](https://badge.fury.io/rb/administrate_ransack.svg)](https://badge.fury.io/rb/administrate_ransack) [![CircleCI](https://circleci.com/gh/blocknotes/administrate_ransack.svg?style=svg)](https://circleci.com/gh/blocknotes/administrate_ransack)
A plugin for [Administrate](https://github.com/thoughtbot/administrate) to use [Ransack](https://github.com/activerecord-hackery/ransack) for filtering resources.

Features:
- add Ransack search results using module prepend inside an Administrate controller;
- offer a filters side bar based on the resource's attributes;
- customize searchable attributes.

## Installation
- After installing Administrate, add to *Gemfile*: `gem 'administrate_ransack'` (and execute `bundle`)
- Edit your admin resource controller adding inside the class body:
```rb
prepend AdministrateRansack::Searchable
```
- Add to your resource index view:
```erb
<%= render('administrate_ransack/filters', attribute_types: page.attribute_types) %>
```
- See the Customizations section to change the attributes list

## Usage
For associations (has many/belongs to) the label used can be customized adding an `admin_label` method to the target model which returns a string while the collection can by filtered with `admin_scope`.

Example:
```rb
class Post < ApplicationRecord
  scope :admin_scope, -> { where(published: true) }

  def admin_label
    title.upcase
  end
end
```

## Notes
- Administrate Search logic works independently from Ransack searches, I suggest to disable it eventually (ex. overriding `show_search_bar?` in the controller)
- Ordering by clicking on the headers of the table preserving the Ransack searches requires a change to the headers links, replacing the th links of *_collection* partial with:
```rb
sort_link(@ransack_results, attr_name) do
  # ...
end
```
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
- Allow only some fields for the filters in the index view:
```erb
<%
attribute_types = {
  title: Administrate::Field::String,
  author: Administrate::Field::BelongsTo,
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
  attribute_labels: attribute_labels
) %>
```
- If you need to define custom search logics you can skip prepending the module (`AdministrateRansack::Searchable`) and create your own search query in a controller, ex:
```ruby
    def scoped_resource
      @ransack_results = super.ransack(params[:q])
      @ransack_results.result(distinct: true)
    end
```
- Optional basic style to setup the filters as a sidebar:
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
![screenshot](screenshot.png)

## Do you like it? Star it!
If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

Or consider offering me a coffee, it's a small thing but it is greatly appreciated: [about me](https://www.blocknot.es/about-me).

## Contributors
- [Mattia Roccoberton](https://blocknot.es/): author

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

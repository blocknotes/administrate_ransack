# frozen_string_literal: true

module AdministrateRansack
  FILTERS = {
    'Administrate::Field::BelongsTo' => :belongs_to,
    'Administrate::Field::Boolean' => :boolean,
    'Administrate::Field::Date' => :date,
    'Administrate::Field::DateTime' => :date,
    'Administrate::Field::Email' => :string,
    'Administrate::Field::HasMany' => :has_many,
    'Administrate::Field::Number' => :number,
    'Administrate::Field::Select' => :select,
    'Administrate::Field::String' => :string,
    'Administrate::Field::Text' => :string
  }.freeze
end

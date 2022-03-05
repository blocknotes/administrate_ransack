# frozen_string_literal: true

module AdministrateRansack
  FILTERS = {
    'Administrate::Field::BelongsTo' => 'field_belongs_to',
    'Administrate::Field::Boolean' => 'field_boolean',
    'Administrate::Field::Date' => 'field_date',
    'Administrate::Field::DateTime' => 'field_date',
    'Administrate::Field::Email' => 'field_string',
    'Administrate::Field::HasMany' => 'field_has_many',
    'Administrate::Field::Number' => 'field_number',
    'Administrate::Field::Select' => 'field_select',
    'Administrate::Field::String' => 'field_string',
    'Administrate::Field::Text' => 'field_string'
  }.freeze
end

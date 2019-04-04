require "administrate/base_dashboard"

class ChommentDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    cross_ref: Field::Polymorphic,
    id: Field::Number,
    message: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    variant: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :user,
    :cross_ref,
    :id,
    :message,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :user,
    :cross_ref,
    :id,
    :message,
    :created_at,
    :updated_at,
    :variant,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :cross_ref,
    :message,
    :variant,
  ].freeze

  # Overwrite this method to customize how chomments are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(chomment)
  #   "Chomment ##{chomment.id}"
  # end
end

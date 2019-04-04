require "administrate/base_dashboard"

class GrabDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    hole: Field::BelongsTo,
    user: Field::BelongsTo,
    memos: Field::HasMany,
    id: Field::Number,
    image_path: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    description: Field::Text,
    media_type: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :hole,
    :user,
    :memos,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :hole,
    :user,
    :memos,
    :id,
    :image_path,
    :created_at,
    :updated_at,
    :description,
    :media_type,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :hole,
    :user,
    :memos,
    :image_path,
    :description,
    :media_type,
  ].freeze

  # Overwrite this method to customize how grabs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(grab)
  #   "Grab ##{grab.id}"
  # end
end

require "administrate/base_dashboard"

class HoleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    subdomain: Field::String,
    chomments_enabled: Field::Boolean,
    chat_enabled: Field::Boolean,
    web_upload_enabled: Field::Boolean,
    private_grabs_enabled: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :subdomain
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :subdomain,
    :created_at,
    :updated_at,
    *Hole::RULES
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :subdomain,
    *Hole::RULES
  ].freeze

  # Overwrite this method to customize how holes are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(hole)
  #   "Hole ##{hole.id}"
  # end
end

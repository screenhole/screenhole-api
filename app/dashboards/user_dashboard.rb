require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    grabs: Field::HasMany,
    chomments: Field::HasMany,
    memos: Field::HasMany,
    notes: Field::HasMany,
    invites: Field::HasMany,
    id: Field::Number,
    username: Field::String,
    password_digest: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    email: Field::String,
    name: Field::String,
    bio: Field::String,
    blocked: Field::Text,
    sup_last_requested_at: Field::DateTime,
    grabs_count: Field::Number,
    country_code: Field::String,
    is_contributor: Field::Boolean,
    is_staff: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :username,
    :email,
    :name,
    :is_contributor,
    :is_staff
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :grabs,
    :chomments,
    :memos,
    :notes,
    :invites,
    :id,
    :username,
    :password_digest,
    :created_at,
    :updated_at,
    :email,
    :name,
    :bio,
    :blocked,
    :sup_last_requested_at,
    :grabs_count,
    :country_code,
    :is_contributor,
    :is_staff,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :grabs,
    :chomments,
    :memos,
    :notes,
    :invites,
    :username,
    :password_digest,
    :email,
    :name,
    :bio,
    :blocked,
    :sup_last_requested_at,
    :grabs_count,
    :country_code,
    :is_contributor,
    :is_staff,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end

require "administrate/base_dashboard"

class MemoDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    hashid: Field::String.with_options(searchable: false),
    user: Field::BelongsTo,
    grab: Field::BelongsTo,
    variant: Field::String.with_options(searchable: false),
    media_path: Field::String,
    message: Field::String,
    pending: Field::Boolean,
    calling_code: Field::Number,
    call_sid: Field::String,
    meta: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :hashid,
    :user,
    :grab,
    :message
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :hashid,
    :user,
    :grab,
    :variant,
    :media_path,
    :message,
    :pending,
    :calling_code,
    :call_sid,
    :meta,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :user,
    :grab,
    :variant,
    :media_path,
    :message,
    :pending,
    :calling_code,
    :call_sid,
    :meta
  ].freeze

  # Overwrite this method to customize how memos are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(memo)
  #   "Memo ##{memo.id}"
  # end
end

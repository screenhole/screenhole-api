class Api::V2::ApplicationController < ActionController::API
  include Knock::Authenticable

  serialization_scope :current_user

  before_action :authenticate_thinko_staff
  before_action :refresh_bearer_auth_header

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def respond_with_errors(object)
    render json: { errors: ErrorSerializer.serialize(object) }, status: :unprocessable_entity
  end

  private

  def authenticate_thinko_staff
    return if ENV['MULTIHOLE_IS_GO'] == 'YES'

    authenticate_user

    return if current_user&.is_staff?

    raise ActionController::RoutingError, 'go away, prole'
  end

  def refresh_bearer_auth_header
    return unless current_user

    headers['Authorization'] = Knock::AuthToken.new(
      payload: current_user.to_token_payload
    ).token
  end

  def load_readable_hole
    @hole = Hole.from_subdomain(params[:hole_id])
  end

  def load_writable_hole
    @hole = current_user.holes.from_subdomain(params[:hole_id])
  end
end

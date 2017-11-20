class ApplicationController < ActionController::API
  include Knock::Authenticable

  serialization_scope :current_user

  before_action :set_raven_context
  before_action :refresh_bearer_auth_header, if: :bearer_auth_header_present

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

    def set_raven_context
      context = {}
      context.merge!({ user_id: current_user.id, email: current_user.email }) unless current_user.blank?
      Raven.user_context(context)
    end

    def bearer_auth_header_present
      request.env["HTTP_AUTHORIZATION"] =~ /Bearer/
    end

    def refresh_bearer_auth_header
      authenticate_user

      if current_user
        headers['Authorization'] = Knock::AuthToken.new(payload: current_user.to_token_payload ).token
      end
    end
end

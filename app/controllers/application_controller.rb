class ApplicationController < ActionController::API
  include Knock::Authenticable

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

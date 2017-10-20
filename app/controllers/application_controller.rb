class ApplicationController < ActionController::API
  include Knock::Authenticable

  before_action :refresh_token, if: :check_auth_header

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  private

    def check_auth_header
      request.env["HTTP_AUTHORIZATION"] =~ /Bearer/
    end

    def refresh_token
      authenticate_user
      headers['Authorization'] = Knock::AuthToken.new(payload: { sub: current_user.id }).token
    end
end

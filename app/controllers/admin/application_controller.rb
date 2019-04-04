module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      @current_admin = authenticate_with_http_basic do |username, password|
        User.find_by(username: username, is_staff: true)&.authenticate(password)
      end

      return request_http_basic_authentication unless @current_admin
    end

    private

    attr_reader :current_admin
    helper_method :current_admin
  end
end

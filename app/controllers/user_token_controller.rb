class UserTokenController < Knock::AuthTokenController
  def refresh
    # authenticate
    # render json: auth_token
    render json: {}
  end
end

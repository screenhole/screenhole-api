class UserTokenController < Knock::AuthTokenController
  def refresh
    authenticate

    render json: { jwt: auth_token.token }
  end
end

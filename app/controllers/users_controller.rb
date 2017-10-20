class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show, :create]

  def show
    render json: User.find_by(username: params[:id])
  end

  def create
    user = User.new(username: auth_params[:username], password: auth_params[:password], password_confirmation: auth_params[:password])

    if user.save
      render json: user, meta: { jwt: Knock::AuthToken.new(payload: user.to_token_payload ).token }
    else
      respond_with_errors(user)
    end
  end

  def current
    render json: current_user
  end

  def refresh_token
    token = Knock::AuthToken.new(payload: current_user.to_token_payload ).token
    render json: { jwt: token }
  end

  def auth_params
    params.require(:auth).permit(:username, :password)
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show, :create]

  def show
    render json: User.find_by(username: params[:id]), include: ['shots.*', 'notes.*']
  end

  def create
    if auth_params[:code] == nil || auth_params[:code] != ENV["INVITE_CODE"]
      return render json: { errors: [
        {
          "status": 422,
          "source": {
            "pointer": "/data/attributes/code"
          },
          "detail": "is invalid"
        }
      ]}, status: :unprocessable_entity
    end

    user = User.new(
      email: auth_params[:email],
      username: auth_params[:username],
      password: auth_params[:password],
      password_confirmation: auth_params[:password]
    )

    if user.save
      render json: user, meta: { jwt: Knock::AuthToken.new(payload: user.to_token_payload ).token }
    else
      respond_with_errors(user)
    end
  end

  def update
    if current_user.update_attributes(auth_params)
      render json: current_user
    else
      respond_with_errors(current_user)
    end
  end

  def current
    render json: current_user, include: ['shots.*', 'notes.*']
  end

  def refresh_token
    token = Knock::AuthToken.new(payload: current_user.to_token_payload ).token
    render json: { jwt: token }
  end

  def auth_params
    params.require(:auth).permit(:email, :username, :password, :password_confirmation, :code, :name, :bio)
  end
end

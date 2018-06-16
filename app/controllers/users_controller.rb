class UsersController < ApplicationController
  before_action :authenticate_user, except: [:show, :create]

  def index
    render json: User.visible_in_directory
  end

  def show
    username = params[:id].strip.downcase if params[:id]
    render json: User.find_by(username: username), include: ['grabs.*', 'notes.*']
  end

  def create
    invite = Invite.find_by(code: (nil || auth_params[:code]).downcase)

    if ! invite || invite.redeemed
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
      invite.update_attribute(:invited_id, user.id)
      jwt_token = Knock::AuthToken.new(payload: user.to_token_payload ).token

      render json: user, meta: { jwt: jwt_token }
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

  def block
    blocked = current_user.blocked

    unless params[:user_id] == current_user.hashid
      blocked.push params[:user_id]
    end

    blocked.uniq!
    blocked.map! { |x| x.is_a?(Integer) ? User.encode_id(x) : x }

    if current_user.update_attribute(:blocked, blocked)
      render json: current_user
    else
      respond_with_errors(current_user)
    end
  end

  def unblock
    blocked = current_user.blocked
    blocked -= [params[:user_id]]

    blocked.uniq!
    blocked.map! { |x| x.is_a?(Integer) ? User.encode_id(x) : x }

    if current_user.update_attribute(:blocked, blocked)
      render json: current_user
    else
      respond_with_errors(current_user)
    end
  end

  def current
    render json: current_user, include: ['grabs.*', 'notes.*']
  end

  def refresh_token
    token = Knock::AuthToken.new(payload: current_user.to_token_payload ).token
    render json: { jwt: token, user: current_user }
  end

  def auth_params
    params.require(:auth).permit(:email, :username, :password, :password_confirmation, :code, :name, :bio)
  end
end

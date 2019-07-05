class Api::V2::UsersController < Api::V2::ApplicationController
  before_action :load_user, only: %i[show]
  before_action :authenticate_user, only: %i[update me]

  def index
    render json: User.visible_in_directory
  end

  def show
    # TODO: is this route used?
    render json: @user, include: ['grabs.*']
  end

  def create
    invite = Invite.where('LOWER(code) = LOWER(?)', invite_params[:code])

    return head :conflict if invite.nil? || invite.redeemed?

    user = User.new(user_params)

    if user.save
      invite.update_attribute(:invited_id, user.id)
      jwt_token = Knock::AuthToken.new(payload: user.to_token_payload).token

      HoleMembership.create!(user: user, hole: invite.hole) if invite.hole

      render json: user, meta: { jwt: jwt_token }
    else
      respond_with_errors(user)
    end
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    else
      respond_with_errors(current_user)
    end
  end

  def me
    @user = current_user
    render :show
  end

  private

  def invite_params
    params.require(:invite).permit(
      :code
    )
  end

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end

  def load_user
    @user = User.where('LOWER(username) = LOWER(?)', params[:id]).take
  end
end

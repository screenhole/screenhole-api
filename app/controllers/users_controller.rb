class UsersController < ApplicationController
  def show
    render json: User.find_by(username: params[:id])
  end

  def create
    User.create(username: auth_params[:username], password: auth_params[:password], password_confirmation: auth_params[:password])
  end

  def current
    render json: current_user
  end

  def auth_params
    params.require(:auth).permit(:username, :password)
  end
end

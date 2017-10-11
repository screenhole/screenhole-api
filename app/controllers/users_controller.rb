class UsersController < ApplicationController
  def create
    puts params
    User.create(username: auth_params[:username], password: auth_params[:password], password_confirmation: auth_params[:password])
  end

  def auth_params
    params.require(:auth).permit(:username, :password)
  end
end

class UploadTokensController < ApplicationController
  before_action :authenticate_user

  def create
    @token = UploadToken.new(user: current_user)
    render json: @token
  end
end
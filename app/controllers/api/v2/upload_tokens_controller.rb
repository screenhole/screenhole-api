class Api::V2::UploadTokensController < Api::V2::ApplicationController
  before_action :authenticate_user

  def create
    @token = UploadToken.new(user: current_user)
    render json: @token
  end
end
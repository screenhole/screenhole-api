require 'rails_helper'

describe Api::V2::GrabsController, type: :controller do
  let(:current_user) { create(:user, is_staff: true) }
  let(:hole) { create(:hole) }
  let(:token) { Knock::AuthToken.new(payload: { sub: current_user.id }).token }
  before do
    HoleMembership.create!(hole: hole, user: current_user)
    request.headers.merge!('Authorization' => "Bearer #{token}")
  end

  describe '#index' do
    it 'returns a 200'
    it 'returns a list of grabs for the given hole'
  end

  describe '#show' do
    it 'returns a 200'
    it 'returns info about the requested grab'
  end

  describe '#create' do
    context 'with valid params' do
      it 'creates a new grab'
      it 'publishes relevant content to ActionCable'
      it 'credits Buttcoin if appropriate'
    end

    context 'with invalid params' do
      it 'returns a 422'
    end
  end

  describe '#destroy' do
    it 'returns a 204'
    it 'publishes to ActionCable'
  end
end

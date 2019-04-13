require 'rails_helper'

describe Api::V2::InvitationsController, type: :controller do
  let(:current_user) { create(:user, is_staff: true) }
  let(:token) { Knock::AuthToken.new(payload: { sub: current_user.id }).token }
  before { request.headers.merge!('Authorization' => "Bearer #{token}") }

  describe '#index' do
    before { create(:invite, user: current_user) }
    subject { get(:index) }

    it 'returns a list of invitations' do
      expect(JSON.parse(subject.body)).to match(
        {
          'invites' => [
            hash_including('code' => anything)
          ]
        }
      )
    end
  end

  describe '#create' do
    subject { post(:create) }

    context 'with sufficient funds' do
      before { current_user.buttcoin_transaction(420) }

      it 'returns a 200' do
        expect(subject.response_code).to be(200)
      end
    end

    context 'with insufficient funds' do
      before { current_user.buttcoin_transaction(-1_000_000) }

      it 'returns a 422' do
        expect(subject.response_code).to be(422)
      end
    end
  end

  describe '#price' do
    let(:price) { 1337 }
    before { allow(Buttcoin::AMOUNTS).to receive(:[]).with(:generate_invite).and_return(price) }
    subject { get(:price) }

    it 'returns the price of an invitation' do
      expect(JSON.parse(subject.body)).to eq({ 'price' => price })
    end
  end
end

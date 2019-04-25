require 'rails_helper'

describe Api::V2::InvitationsController, type: :controller do
  let(:current_user) { create(:user, is_staff: true) }
  let(:hole) { create(:hole) }
  let(:token) { Knock::AuthToken.new(payload: { sub: current_user.id }).token }
  before do
    HoleMembership.create!(hole: hole, user: current_user)
    request.headers.merge!('Authorization' => "Bearer #{token}")
  end

  describe '#index' do
    before { create(:invite, user: current_user, hole: hole) }
    subject { get(:index, params: { hole_id: hole.subdomain }) }

    it 'returns a list of invitations' do
      expect(JSON.parse(subject.body)).to match(
        'invites' => [
          hash_including('code' => anything)
        ]
      )
    end
  end

  describe '#create' do
    subject { post(:create, params: { hole_id: hole.subdomain }) }

    context 'with sufficient funds' do
      before { current_user.buttcoin_transaction(420) }

      it 'returns a 200' do
        expect(subject.response_code).to be(200)
      end

      it 'debits buttcoin'
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
    subject { get(:price, params: { hole_id: hole.subdomain }) }

    it 'returns the price of an invitation' do
      expect(JSON.parse(subject.body)).to eq('price' => price)
    end
  end
end

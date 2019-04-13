require 'rails_helper'

describe Api::V2::CurrencyController, type: :controller do
  let(:current_user) { create(:user, is_staff: true) }
  let(:token) { Knock::AuthToken.new(payload: { sub: current_user.id }).token }
  before { request.headers.merge!('Authorization' => "Bearer #{token}") }

  describe '#index' do
    subject { get(:index) }

    it 'returns a 200' do
      expect(subject.response_code).to be(200)
    end

    context 'with some transactions' do
      before do
        create(:buttcoin, user: current_user, amount: 420)
        create(:buttcoin, user: current_user, amount: -69)
      end

      it 'reflects them in the response' do
        expect(JSON.parse(subject.body)).to match(
          'earned' => 420,
          'spent' => 69,
          'profit' => 351
        )
      end
    end
  end

  describe '#trends' do
    subject { get(:trends) }

    it 'returns a 410' do
      expect(subject.response_code).to be(410)
    end
  end
end

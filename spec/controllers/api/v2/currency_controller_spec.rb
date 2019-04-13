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
      let(:subtraction) { 69 }
      let!(:balance) { current_user.buttcoin_balance }
      before { create(:buttcoin, user: current_user, amount: -subtraction) }

      it 'reflects them in the response' do
        expect(JSON.parse(subject.body)).to match(
          'earned' => balance,
          'spent' => subtraction,
          'profit' => balance - subtraction
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

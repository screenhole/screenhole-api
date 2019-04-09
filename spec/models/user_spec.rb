require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    it { is_expected.to allow_value('peterParker_2018').for(:username) }
    it { is_expected.to_not allow_value('sam@example.com').for(:username) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:hole_memberships) }
    it { is_expected.to have_many(:holes).through(:hole_memberships) }
  end

  describe '.from_token_payload' do
    let(:user) { create(:user) }
    subject { described_class.from_token_payload(token_payload) }

    context 'with a payload containing a sub' do
      let(:token_payload) { { 'sub' => user.hashid } }

      it 'returns the expected user' do
        expect(subject).to eq(user)
      end
    end

    context 'with a JWT' do
      let(:token_payload) do
        Base64.encode64(
          Knock::AuthToken.new(payload: { sub: user.id }).token
        )
      end

      it 'returns the expected user' do
        expect(subject).to eq(user)
      end
    end

    context 'with a guest token' do
      let(:token_payload) { Base64.encode64('guest') }

      it 'returns nil' do
        expect(subject).to be nil
      end
    end

    context 'with anything else' do
      let(:token_payload) { 'rabbits' }

      it 'returns nil' do
        expect(subject).to be nil
      end
    end
  end

  describe '#badges' do
    it 'returns a non-empty array' do
      expect(subject.badges).to_not be_empty
    end
  end
end

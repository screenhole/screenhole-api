require 'rails_helper'

describe User, type: :model do
  subject { create(:user) }

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

  describe '#country_code' do
    it 'only accepts valid countries' do
      subject.country_code = 'cheese'
      expect(subject.valid?).to be false
    end
  end

  describe '#country_emoji' do
    context 'with no country_code set' do
      it 'returns a checkered flag' do
        expect(subject.country_emoji).to eq('🏁')
      end
    end

    context 'with a country code set' do
      subject { create(:user, country_code: 'FI') }

      it 'returns the relevant flag' do
        expect(subject.country_emoji).to eq('🇫🇮')
      end
    end
  end

  describe '#time_now' do
    context 'when no country_code is set' do
      it 'returns nil' do
        expect(subject.country_code).to be nil
      end
    end

    context 'with a country code set' do
      subject { create(:user, country_code: 'FI' )}

      it 'returns a time' do
        expect(subject.time_now).to match(/^\d{2}:\d{2}$/)
      end
    end
  end

  describe '#badges' do
    it 'returns a non-empty array' do
      expect(subject.badges).to_not be_empty
    end
  end
end

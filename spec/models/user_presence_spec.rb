require 'rails_helper'

describe UserPresence do
  let(:redis_client) { double }
  let(:user) { 1 }
  subject { described_class.new(user, redis_client) }

  describe '#initialize' do
    context 'with a user id' do
      it 'instantiates based on the supplied user id' do
        expect { subject }.to_not raise_error
      end
    end

    context 'with a user model' do
      let(:user) { double('User', id: 1234) }

      it 'instantiates based on the supplied user model id' do
        expect { subject }.to_not raise_error
      end
    end
  end

  describe 'present!' do
    it 'adds the user ID to a redis set' do
      expect(redis_client).to receive(:sadd).with(anything, user)
      subject.present!
    end
  end

  describe 'gone!' do
    it 'removes the user ID from a redis set' do
      expect(redis_client).to receive(:srem).with(anything, user)
      subject.gone!
    end
  end

  describe 'present?' do
    it 'determines if the user ID is in the redis set' do
      aggregate_failures do
        expect(redis_client).to receive(:sismember).with(anything, user).and_return(true)
        expect(subject.present?).to eq(true)
      end
    end
  end
end

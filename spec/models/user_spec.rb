require 'rails_helper'

describe User do
  describe 'presence delegations' do
    let(:user_presence) { double }

    before do
      allow(UserPresence).to receive(:new).and_return(user_presence)
    end

    describe '#present?' do
      it 'calls an underlying UserPresence instance' do
        expect(user_presence).to receive(:present?)
        subject.present?
      end
    end

    describe '#present!' do
      it 'calls an underlying UserPresence instance' do
        expect(user_presence).to receive(:present!)
        subject.present!
      end
    end

    describe '#gone!' do
      it 'calls an underlying UserPresence instance' do
        expect(user_presence).to receive(:gone!)
        subject.gone!
      end
    end
  end
end

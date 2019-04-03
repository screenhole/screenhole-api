require 'rails_helper'

describe Note, type: :model do
  describe '#can_broadcast?' do
    subject { create(:note, variant: variant).can_broadcast? }

    context 'with a variant of chomment' do
      let(:variant) { 'chomment' }
      it { is_expected.to be true }
    end

    context 'with a variant of at_reply' do
      let(:variant) { 'at_reply' }
      it { is_expected.to be true }
    end

    context 'with a variant of voice_memo' do
      let(:variant) { 'voice_memo' }
      it { is_expected.to be false }
    end
  end
end

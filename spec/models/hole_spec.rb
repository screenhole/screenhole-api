require 'rails_helper'

RSpec.describe Hole, type: :model do
  describe 'validation' do
    let(:hole) { build(:hole) }

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
    end

    describe 'subdomain' do
      it { is_expected.to validate_presence_of(:subdomain) }
      it { is_expected.to validate_exclusion_of(:subdomain).in_array(['www', '404']) }
      it { is_expected.to validate_length_of(:subdomain).is_at_least(3) }
      it { is_expected.to validate_length_of(:subdomain).is_at_most(30) }
      it { is_expected.to allow_value('abc-def-123').for(:subdomain) }
      it { is_expected.to_not allow_value('With Non-Alpha Chars!').for(:subdomain) }
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:grabs) }
  end
end

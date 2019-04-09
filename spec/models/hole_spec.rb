require 'rails_helper'

RSpec.describe Hole, type: :model do
  subject { create(:hole) }

  describe 'validation' do
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

      describe 'generic blacklist' do
        it { is_expected.to_not allow_value('telnet').for(:subdomain) }
      end

      describe 'hard blacklist' do
        describe 'exact match' do
          Hole::HARD_BLACKLIST_EXACT_MATCH.each do |phrase|
            it { is_expected.to_not allow_value(phrase).for(:subdomain) }
          end
        end

        describe 'regex' do
          it { is_expected.to_not allow_value('thinko-hiring').for(:subdomain) }
          it { is_expected.to_not allow_value('screenhole-admin').for(:subdomain) }
          it { is_expected.to_not allow_value('free-lenovo-thinkpad').for(:subdomain) }
        end
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:grabs) }
    it { is_expected.to have_many(:hole_memberships) }
    it { is_expected.to have_many(:users).through(:hole_memberships) }
  end

  describe '#owner' do
    it 'returns the owner of the hole' do
      expect(subject.owner).to be_a(User)
    end
  end

  describe '#rules' do
    it 'returns a hash of rules' do
      expect(subject.rules).to include(
        {
          chomments_enabled: false,
          web_upload_enabled: false,
          private_grabs_enabled: false,
          chat_enabled: false
        }
      )
    end
  end
end

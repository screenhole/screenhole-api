require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:hole) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:hole) }
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_length_of(:message).is_at_least(3) }
    it { is_expected.to validate_length_of(:message).is_at_most(255) }
  end
end

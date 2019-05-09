require 'rails_helper'

RSpec.describe GrabTip, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:grab) }
    it { is_expected.to belong_to(:user) }
  end
end

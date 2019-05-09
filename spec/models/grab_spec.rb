require 'rails_helper'

describe Grab, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:hole).optional }
    it { is_expected.to have_many(:grab_tips) }
  end
end

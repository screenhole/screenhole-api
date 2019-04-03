require 'rails_helper'

describe Grab, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:hole).optional }
  end
end

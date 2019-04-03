require 'rails_helper'

describe Blacklist do
  describe '.words' do
    it 'returns a list of banned words' do
      expect(described_class.words).to be_an(Array)
      expect(described_class.words[0]).to be_a(String)
    end
  end
end

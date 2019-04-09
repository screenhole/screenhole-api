require 'rails_helper'

describe UploadToken do
  let(:kid) { 'ooh fake kid' }
  let(:jwt_secret) { 'ooh fake secret' }
  let(:endpoint) { 'http://example.com' }

  before do
    allow(ENV).to receive(:fetch).with('ACCELERATOR_KID').and_return(kid)
    allow(ENV).to receive(:fetch).with('ACCELERATOR_JWT_SECRET').and_return(jwt_secret)
    allow(ENV).to receive(:fetch).with('ACCELERATOR_ENDPOINT', anything).and_return(endpoint)
  end

  let(:user) { create(:user) }
  subject { described_class.new(user: user) }

  describe '#path' do
    it 'returns a path including the user hashid' do
      expect(subject.path).to start_with("/#{user.hashid}")
    end
  end

  describe '#url' do
    it 'returns a full URL including the path' do
      expect(subject.url).to start_with("http://example.com/#{user.hashid}")
    end
  end

  describe '#token' do
    let(:decoded_token) { JWT.decode(subject.token, 'cheese', false) }
    let(:decoded_header) { decoded_token[1] }
    let(:decoded_claim) { decoded_token[0] }

    it 'returns a JSON web token' do
      expect(decoded_token).to_not be_nil
    end

    it 'includes a valid header' do
      expect(decoded_header).to include(
        'alg' => 'HS256',
        'kid' => kid
      )
    end

    it 'includes a valid claim' do
      expect(decoded_claim).to include(
        'method' => 'PUT',
        'url' => anything,
        'exp' => anything
      )
    end
  end
end

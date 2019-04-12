require 'rails_helper'

describe Api::V2::UploadTokensController, type: :controller do
  let(:current_user) { create(:user) }
  let(:token) { Knock::AuthToken.new(payload: { sub: current_user.id }).token }
  before { request.headers.merge!('Authorization' => "Bearer #{token}") }

  before do
    allow(UploadToken).to receive(:new).and_return(
      instance_double(UploadToken, token: 'cheese', path: '/butts', url: 'http://example.com/butts')
    )
  end

  describe '#create' do
    subject { post(:create) }

    it 'returns a 200' do
      expect(subject.response_code).to be(200)
    end
  end
end

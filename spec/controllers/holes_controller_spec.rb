require 'rails_helper'

describe HolesController, type: :controller do
  let(:token) { Knock::AuthToken.new(payload: { sub: create(:user).id }).token }
  before { request.headers.merge!('Authorization' => "Bearer #{token}") }

  describe '#create' do
    let(:name) { 'foo' }
    let(:subdomain) { 'foo' }
    let(:params) { { hole: { subdomain: subdomain, name: name } } }
    subject { post(:create, params: params) }

    context 'with valid parameters' do
      it 'returns a 200' do
        expect(subject.response_code).to be(200)
      end

      it 'returns a JSON body' do
        expect(JSON.parse(subject.body)).to eq('hole' => { 'name' => 'foo', 'subdomain' => 'foo' })
      end
    end

    describe 'with invalid parameters' do
      let(:subdomain) { 'i like big buttcoin and i cannot lie' }

      it 'returns a 422' do
        expect(subject.response_code).to be(422)
      end
    end
  end
end

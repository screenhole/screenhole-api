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

  describe '#show' do
    let(:hole) { create(:hole) }
    subject { get(:show, params: { id: subdomain }) }

    context 'with a non-existent subdomain' do
      let(:subdomain) { 'big-butts' }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with an existing subdomain' do
      let(:subdomain) { hole.subdomain }

      it 'returns a 200' do
        expect(subject.response_code).to be(200)
      end

      it 'returns a JSON body' do
        expect(JSON.parse(subject.body)).to eq('hole' => { 'name' => hole.name, 'subdomain' => hole.subdomain })
      end
    end
  end
end

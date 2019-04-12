require 'rails_helper'

describe HolesController, type: :controller do
  let(:current_user) { create(:user, is_staff: true) }
  let(:token) { Knock::AuthToken.new(payload: { sub: current_user.id }).token }
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
        expect(JSON.parse(subject.body)['hole']).to include('name' => 'foo', 'subdomain' => 'foo')
      end

      it 'sets the current user as the hole owner' do
        subject
        expect(Hole.find_by!(subdomain: subdomain).owner).to eq(current_user)
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
    before { create(:hole_membership, user: current_user, hole: hole) }
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
        expect(JSON.parse(subject.body)['hole']).to include('name' => hole.name, 'subdomain' => hole.subdomain)
      end
    end
  end

  describe '#update' do
    let(:name) { 'foo' }
    let(:subdomain) { 'foo' }
    let(:params) { { hole: { subdomain: subdomain, name: name } } }
    let(:hole) { create(:hole) }
    before { hole.hole_memberships << HoleMembership.new(user: current_user, created_at: '1970-01-01'); hole.save! }
    subject { put(:update, params: { id: hole.subdomain }.merge(params)) }

    context 'with valid parameters' do
      it 'returns a 200' do
        expect(subject.response_code).to be(200)
      end

      it 'returns a JSON body' do
        expect(JSON.parse(subject.body)['hole']).to include('name' => 'foo', 'subdomain' => 'foo')
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

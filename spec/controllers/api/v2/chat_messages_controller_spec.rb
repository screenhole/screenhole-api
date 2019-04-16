require 'rails_helper'

describe Api::V2::ChatMessagesController, type: :controller do
  let(:current_user) { create(:user, is_staff: true) }
  let(:hole) { create(:hole) }
  let(:token) { Knock::AuthToken.new(payload: { sub: current_user.id }).token }
  before do
    HoleMembership.create!(hole: hole, user: current_user)
    request.headers.merge!('Authorization' => "Bearer #{token}")
  end

  describe '#index' do
    before { create(:chat_message, hole: hole, message: 'i got horses in the back') }
    subject { get(:index, params: { hole_id: hole.subdomain }) }

    it 'returns an HTTP 200' do
      expect(subject.response_code).to be(200)
    end

    it "includes a message with content 'i got horses in the back'" do
      expect(JSON.parse(subject.body)).to include(
        'chat_messages' => [
          hash_including('message' => 'i got horses in the back')
        ]
      )
    end
  end

  describe '#create' do
    let(:message) { 'trying to sneak around but dummy thicc' }
    let(:params) { { chat_message: { message: message } } }
    subject { post(:create, params: { hole_id: hole.subdomain }.merge(params)) }

    context 'with a valid message' do
      it 'returns a 201' do
        expect(subject.response_code).to be(201)
      end

      it 'notifies any users mentioned in the message'
      it 'credits some Buttcoin to the user'
      it 'publishes the message to ActionCable'
    end

    context 'with an invalid message' do
      let(:message) { 'thicc' * 1000 }

      it 'returns a 422' do
        expect(subject.response_code).to be(422)
      end
    end
  end

  describe '#destroy' do
    let(:chat_message) { create(:chat_message, hole: hole, user: current_user) }
    subject { delete(:destroy, params: { hole_id: hole.subdomain, id: chat_message.id }) }

    it 'returns a 204' do
      expect(subject.response_code).to be(204)
    end

    it 'publishes deletion over ActionCable'
  end

  describe '#legacy_index' do
    subject { get(:legacy_index) }
    before { create(:chomment) }

    it 'returns a list of old-style chomments' do
      body = JSON.parse(subject.body)
      expect(body).to have_key('chat_messages')
      expect(body['chat_messages']).to_not be_empty
    end
  end
end

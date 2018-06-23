# frozen_string_literals: true
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#from_token_payload with sub' do
    user = users(:one)

    token = {}
    token["sub"] = user.hashid

    result = User.from_token_payload(token)

    assert_equal user.id, result.id
  end

  test '#from_token_payload with jwt token for connection#find_verified_user' do
    user = users(:one)
    _token = Knock::AuthToken.new(payload: { sub: user.id }).token
    _encoded_token = Base64.encode64(_token)

    result = User.from_token_payload(_encoded_token)

    assert_equal user.id, result.id
  end

    test '#from_token_payload with guest token for action cable connect' do
    _token = "guest"
    _encoded_token = Base64.encode64(_token)

    result = User.from_token_payload(_encoded_token)

    assert_nil result

    _token = "anything else really"
    _encoded_token = Base64.encode64(_token)

    result = User.from_token_payload(_encoded_token)

    assert_nil result
  end
end
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

  test '#country_emoji returns a checkered flag if no country_code is set' do
    user = users(:one)

    assert_equal user.country_emoji, '🏁'
  end

  test '#country_emoji returns the relevant flag if a valid country_code is set' do
    user = users(:one)
    user.country_code = 'FI'

    assert_equal user.country_emoji, '🇫🇮'
  end

  test 'country_code only accepts valid countries' do
    user = users(:one)
    user.country_code = 'big dick energy'
    assert_equal user.valid?, false
  end

  test '#awards returns a non-empty array' do
    user = users(:one)
    assert(user.awards.count > 0)
  end
end

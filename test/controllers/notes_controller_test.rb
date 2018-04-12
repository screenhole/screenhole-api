require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  test 'should respond not authorized #any' do
    get sup_any_url

    assert_response 401
  end

  test 'should respond not authorized #index' do
    get sup_url

    assert_response 401
  end

  test 'should return 0 pending notifications #any' do
    user = users(:buttcoin_millionaire)

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    inline_headers = {
      'Authorization': "Bearer #{token}"
    }

    get sup_any_url, headers: inline_headers

    response = JSON.parse(@response.body)

    assert_response :success
    assert_equal 0, response['pending']
  end

  test 'should return pending notifications count #any' do
    user = users(:one)

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    inline_headers = {
      'Authorization': "Bearer #{token}"
    }

    get sup_any_url, headers: inline_headers

    response = JSON.parse(@response.body)

    assert_response :success
    assert_equal 1, response['pending']
  end

  test 'should return pending notifications #index' do
    user = users(:one)

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    inline_headers = {
      'Authorization': "Bearer #{token}"
    }

    get sup_url, headers: inline_headers

    response_data = JSON.parse(@response.body)
    notes_data = response_data['notes']

    assert_response :success
    assert_equal 1, notes_data.count
  end
end

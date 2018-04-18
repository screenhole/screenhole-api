require 'test_helper'

class MemosControllerTest < ActionDispatch::IntegrationTest
  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  test 'it responds unauthorized #create' do
    grab = grabs(:one)

    params = {
      memo: {
        variant: '',
        pending: '',
        media_path: '',
        message: '',
        meta: ''
      }
    }

    post "/grabs/#{grab.hashid}/memos", params: params

    assert_response :unauthorized
  end

  test 'it does not create a chomment on a grab b/c not enough buttcoin #create' do
    grab = grabs(:one)

    params = {
      memo: {
        variant: 'chomment',
        pending: true,
        media_path: '',
        message: 'wow this is awesome share thnx',
        meta: ''
      }
    }

    post "/grabs/#{grab.hashid}/memos", params: params, headers: authenticated_header

    assert_response :unprocessable_entity

    result_data = JSON.parse(@response.body)
    error_data = result_data['error']

    assert_response :unprocessable_entity
    assert_equal 'not enough buttcoin', error_data
  end

  test 'it does create a chomment on a grab #create' do
    grab = grabs(:two)
    user = users(:buttcoin_millionaire)

    params = {
      memo: {
        variant: 'chomment',
        pending: true,
        media_path: '',
        message: 'wow this is awesome share thnx',
        meta: ''
      }
    }

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    inline_headers = {
      'Authorization': "Bearer #{token}"
    }

    assert_difference('Note.count') do
      post "/grabs/#{grab.hashid}/memos", params: params, headers: inline_headers
    end

    assert_response :success

    result_data = JSON.parse(@response.body)

    assert_equal grab.hashid, result_data['memo']['grab']['id']
  end
end

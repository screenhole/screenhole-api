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
    EXPECTED_NOTES_COUNT = user.notes.count

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    inline_headers = {
      'Authorization': "Bearer #{token}"
    }

    get sup_any_url, headers: inline_headers

    response = JSON.parse(@response.body)

    assert_response :success
    assert_equal EXPECTED_NOTES_COUNT, response['pending']
  end

  test 'should return pending notifications #index' do
    user = users(:one)

    COUNT_PER_PAGE = 25

    user_notes_count = user.notes.count
    total_pages = (user_notes_count / COUNT_PER_PAGE.to_f).ceil

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    inline_headers = {
      'Authorization': "Bearer #{token}"
    }

    get sup_url, headers: inline_headers

    assert_response :success

    response_data = JSON.parse(@response.body)
    notes_data = response_data['notes']
    meta_data = response_data['meta']

    assert_equal COUNT_PER_PAGE, notes_data.count
    assert_equal user_notes_count, meta_data['total_count']
    assert_equal 1, meta_data['current_page']
    assert_equal total_pages, meta_data['total_pages']
  end

  test 'should respond to pagination of notifications #index' do
    user = users(:one)

    EXPECTED_PAGE = 1
    EXPECTED_TOTAL_PAGES = 1
    COUNTS_PER_PAGE = 121

    params = {
      per_page: COUNTS_PER_PAGE
    }

    token = Knock::AuthToken.new(payload: { sub: user.id }).token

    inline_headers = {
      'Authorization': "Bearer #{token}"
    }

    get sup_url, params: params, headers: inline_headers

    response_data = JSON.parse(@response.body)
    notes_data = response_data['notes']
    meta_data = response_data['meta']

    assert_response :success

    assert_equal COUNTS_PER_PAGE, notes_data.count
    assert_equal EXPECTED_PAGE, meta_data['current_page']
    assert_equal EXPECTED_TOTAL_PAGES, meta_data['total_pages']
  end
end

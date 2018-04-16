require 'test_helper'

class ButtcoinsControllerTest < ActionDispatch::IntegrationTest
  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  test 'responds not authorized for not logged in users #index' do
    get '/buttcoins'

    assert_response :unauthorized
  end

  test 'responds not authorized for not logged in users #trends' do
    get '/buttcoins/trends'

    assert_response :unauthorized
  end

  test 'responds with correct data for past 24 hours #index' do
    get buttcoins_url, headers: authenticated_header

    assert_response :success

    response_data = JSON.parse(response.body)

    expected_spent = -10_000
    expected_profit = -9998

    assert_equal 2, response_data['earned']
    assert_equal expected_spent, response_data['spent']
    assert_equal expected_profit, response_data['profit']
  end

  test 'responds with correct data for past 7 days trends #trends' do
    get buttcoins_trends_url, headers: authenticated_header

    assert_response :success

    response_data = JSON.parse(response.body)

    expected_spent = -10_000
    expected_profit = -4388

    assert_equal 5612, response_data['earned']
    assert_equal expected_spent, response_data['spent']
    assert_equal expected_profit, response_data['profit']
  end
end

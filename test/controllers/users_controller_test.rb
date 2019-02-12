require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  test 'should return a list of users from #index' do
    get('/users', headers: authenticated_header)

    assert_response(:success)

    users = JSON.parse(@response.body).try(:[], 'users')

    assert_not_nil(users)
    assert_kind_of(Array, users)
  end

  test 'should not allow access to list of users if non-authenticated' do
    get('/users')
    assert_response(401)
  end

  test 'should get #show' do
    user = users(:one).username

    get "/users/#{user}/"

    result_data = JSON.parse(@response.body)
    user_data = result_data['user']

    assert_response :success
    assert_equal 'getaclue_1', user_data['username']
    assert_equal 'Alex Kluew', user_data['name']
    assert_equal 'Software Engineer, EIT - I read your beautifully tracked emails using plain text - https://dailyvibes.ca  – http://elderoost.com  – http://t.me/getaclue', user_data['bio']
  end

  test 'includes a country code and emoji if supplied' do
    user = users(:one)
    user.country_code = 'SE'
    user.save!

    get "/users/#{user.username}"

    result = JSON.parse(@response.body)['user']

    assert_response :success
    assert_equal 'SE', result['country_code']
    assert_equal '🇸🇪', result['country_emoji']
  end

  test 'includes a time_now if supplied' do
    user = users(:one)
    user.country_code = 'SE'
    user.save!

    get "/users/#{user.username}"

    result = JSON.parse(@response.body)['user']

    assert_match(/^\d{2}:\d{2}$/, result['time_now'])
  end

  test 'includes some badgers' do
    user = users(:one)
    user.save!

    get "/users/#{user.username}"

    result = JSON.parse(@response.body)['user']

    assert(result['badgers'].count > 0)
  end

  test 'should ignore username case sensitivity in #show' do
    get "/users/getaclue_1"

    result_data_1 = JSON.parse(@response.body)
    user_data_1 = result_data_1['user']

    assert_equal 'getaclue_1', user_data_1['username']

    get "/users/Getaclue_1"

    result_data_2 = JSON.parse(@response.body)
    user_data_2 = result_data_2['user']

    assert_equal 'getaclue_1', user_data_2['username']

    get "/users/GeTaClUe_1"

    result_data_3 = JSON.parse(@response.body)
    user_data_3 = result_data_3['user']

    assert_equal 'getaclue_1', user_data_3['username']
  end

  test 'should respond not authorized without auth header #update' do
    post current_users_url

    assert_response 401
  end

  test 'should update user #update' do
    params = {
      auth: {
        username: 'getaclue',
        email: 'info@getaclue.me',
        name: 'Kluew Alex',
        bio: 'Hello World',
        password: 'newp4ssw0rd',
        password_confirmation: 'newp4ssw0rd'
      }
    }

    post current_users_url, params: params, headers: authenticated_header

    result_data = JSON.parse(@response.body)
    user_data = result_data['user']

    assert_response :success
    assert_equal 'getaclue', user_data['username']
    assert_equal 'info@getaclue.me', user_data['email']
    assert_equal 'Kluew Alex', user_data['name']
    assert_equal 'Hello World', user_data['bio']
  end

  test 'should not update user #update' do
    params = {
      auth: {
        username: '',
        email: ''
      }
    }

    post current_users_url, params: params, headers: authenticated_header

    assert_response :unprocessable_entity
  end

  test 'should not retreive current user data without auth header #current' do
    get current_users_url

    assert_response :unauthorized
  end

  test 'should not refresh user auth token without auth header #refresh_token' do
    get token_refresh_users_url

    assert_response :unauthorized
  end

  test 'should refresh user auth token #refresh_token' do
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token
    authenticated_header_test = {
      'Authorization': "Bearer #{token}"
    }

    get token_refresh_users_url, headers: authenticated_header_test

    assert_response :success

    result_data = JSON.parse(@response.body)
    jwt_data = result_data['jwt']
    user_data = result_data['user']

    assert_not_nil jwt_data
    assert_not_same token, jwt_data
    assert_equal 'getaclue_1', user_data['username']
    assert_equal 'Alex Kluew', user_data['name']
    assert_equal 'Software Engineer, EIT - I read your beautifully tracked emails using plain text - https://dailyvibes.ca  – http://elderoost.com  – http://t.me/getaclue', user_data['bio']
  end

  test 'should not block user without auth header #block' do
    post '/users/123456/block'

    assert_response :unauthorized
  end

  test 'should block user #block' do
    # this doesn't actually seem to do anything on backend?
    post '/users/123456/block', headers: authenticated_header
    assert_response :success

    result_data = JSON.parse(@response.body)
    user_data = result_data['user']

    assert_equal ['123456'], user_data['blocked']

    post '/users/789101/block', headers: authenticated_header

    assert_response :success

    result_data = JSON.parse(@response.body)
    user_data = result_data['user']

    assert_equal %w[123456 789101], user_data['blocked']
  end

  test 'should not unblock user without auth header #unblock' do
    post '/users/123456/unblock'

    assert_response :unauthorized
  end

  test 'should unblock user #unblock' do
    user = users(:three_w_blocked)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    authenticated_header_test = {
      'Authorization': "Bearer #{token}"
    }

    post '/users/13419/unblock', headers: authenticated_header_test
    assert_response :success

    result_data = JSON.parse(@response.body)
    user_data = result_data['user']

    assert_equal %w[12345 67890], user_data['blocked']
  end

  test 'should not create user based on invite #create' do
    invite_code = invites(:one)

    params = {
      auth: {
        code: invite_code.code,
        username: '',
        email: '',
        password: ''
      }
    }

    post users_url, params: params

    assert_response :unprocessable_entity
  end

  test 'should not create user based on redeemed invite #create' do
    invite_code = invites(:two_redeemed)

    params = {
      auth: {
        code: invite_code.code
      }
    }

    post users_url, params: params

    assert_response :unprocessable_entity

    result_data = JSON.parse(@response.body)
    error_data = result_data['errors'].first

    assert_equal 422, error_data['status']
    assert_equal '/data/attributes/code', error_data['source']['pointer']
    assert_equal 'is invalid', error_data['detail']
  end

  test 'should create user based on invite #create' do
    invite_code = invites(:one)

    params = {
      auth: {
        code: invite_code.code,
        username: 'batman',
        email: 'bat@man.com',
        password: 'password'
      }
    }

    post users_url, params: params

    assert_response :success

    invite_code.reload

    result_data = JSON.parse(@response.body)
    user_data = result_data['user']

    user = User.find(user_data['id'])

    assert_equal invite_code.invited_id, user.id
  end

  # test 'should retreive current user data #current' do
  #   # failing in:
  #   # render json: current_user, include: ['grabs.*', 'notes.*']
  #   # fail removed if removed include
  #   # fail msg:
  #   #     UsersControllerTest#test_should_retreive_current_user_data_#current:
  #   # NameError: wrong constant name Cross ref
  #   #     app/controllers/users_controller.rb:79:in `current'
  #   #     test/controllers/users_controller_test.rb:76:in `block in <class:UsersControllerTest>'

  #   get current_users_url, headers: authenticated_header

  #   result_data = JSON.parse(@response.body)
  #   user_data = result_data['user']

  #   assert_response :success
  #   # assert_equal 'getaclue_1', user_data['username']
  #   # assert_equal 'Alex Kluew', user_data['name']
  #   # assert_equal 'Software Engineer, EIT - I read your beautifully tracked emails using plain text - https://dailyvibes.ca  – http://elderoost.com  – http://t.me/getaclue', user_data['bio']
  # end
end

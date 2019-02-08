class CountriesControllerTest < ActionDispatch::IntegrationTest
  def authenticated_header
    token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  test '#index returns a fascinating list of country codes' do
    get('/countries', headers: authenticated_header)

    assert_response(:success)

    countries = JSON.parse(@response.body)['countries']

    assert_includes(countries, { 'name' => 'Sweden', 'code' => 'SE', 'emoji' => '🇸🇪' })
  end
end

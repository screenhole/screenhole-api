class CountriesController < ApplicationController
  before_action :authenticate_user

  def index
    render json: {
      countries: ISO3166::Country.all.map do |c|
        {
          name: c.name,
          code: c.alpha2,
          emoji: c.emoji_flag
        }
      end.sort_by { |c| c[:name] }
    }
  end
end

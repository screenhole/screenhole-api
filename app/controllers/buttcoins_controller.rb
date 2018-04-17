class ButtcoinsController < ApplicationController
  before_action :authenticate_user

  def index
    results = process_buttcoins_for(24.hours.ago..Time.now)

    render json: results
  end

  def trends
    results = process_grouped_buttcoins_for(12.days.ago..Time.now)

    render json: results
  end

  private

  def process_buttcoins_for(dates)
    return unless dates

    buttcoin_entries = Buttcoin.where(user: current_user, updated_at: dates)

    earned = spent = profit = 0

    buttcoin_entries.each do |entry|
      if entry.amount.positive?
        earned += entry.amount
      else
        spent += entry.amount
      end
      profit += entry.amount
    end

    result = {
      earned: earned,
      spent: spent,
      profit: profit
    }

    result
  end

  def process_grouped_buttcoins_for(dates)
    return unless dates

    buttcoin_entries = Buttcoin.where(user: current_user, updated_at: dates)
    orderd_buttcoin_entries = buttcoin_entries.order("date_trunc('day', updated_at) desc")

    results = {}

    orderd_buttcoin_entries.each do |entry|
      current_date = entry.updated_at.strftime('%F')

      unless results.key?(current_date)
        results[current_date] = {
          earned: 0,
          spent: 0,
          profit: 0,
          for_date: current_date
        }
      end

      if entry.amount.positive?
        results[current_date][:earned] += entry.amount
      else
        results[current_date][:spent] += entry.amount
      end
      results[current_date][:profit] += entry.amount
    end

    results.values
  end
end

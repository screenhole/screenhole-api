class ButtcoinsController < ApplicationController
  before_action :authenticate_user

  def index
    results = process_buttcoins_for(24.hours.ago..Time.now)

    render json: results
  end

  def trends
    results = process_buttcoins_for(12.days.ago..Time.now)

    render json: results
  end

  private

  def process_buttcoins_for(dates)
    return unless dates
    
    buttcoin_entries = Buttcoin.where(updated_at: dates)

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
end

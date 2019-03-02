class BallerBadge < BaseBadge
  BALLER_THRESHOLD = 0.1.freeze # 10%

  def id
    'baller'
  end

  def metadata
    {
      user_gain: user_gain,
      global_gain: global_gain,
      user_gain_relative_to_global_gain: user_gain_relative_to_global_gain
    }
  end

  # If user has added >= 10% of the global buttcoin market's value
  # in buttcoin over the past 24 hours, yes, otherwise no.
  #
  # This is genuinely insane.
  def eligible?
    user_gain_relative_to_global_gain > BALLER_THRESHOLD
  end

  private

  def user_gain_relative_to_global_gain
    user_gain.to_f / global_gain.to_f
  end

  def user_gain
    @user_gain ||= daily_butts.where(user_id: user.id).sum(:amount)
  end

  def global_gain
    @global_gain ||= daily_butts.sum(:amount)
  end

  def daily_butts
    Buttcoin.where('created_at > ?', 24.hours.ago)
  end
end

class ButtcoinBalance
  def initialize(user:, since:)
    @user = user
    @since = since
  end

  def earned
    @earned ||= query.where('amount > 0').sum(:amount)
  end

  def spent
    @spent ||= -query.where('amount <= 0').sum(:amount)
  end

  def profit
    @profit ||= earned - spent
  end

  def to_json(*)
    {
      earned: earned,
      spent: spent,
      profit: profit
    }.to_json
  end

  private

  attr_reader :user, :since

  def query
    Buttcoin.where('user_id = ? AND created_at > ?', user.id, since)
  end
end

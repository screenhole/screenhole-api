class ElderlyBadger < BaseBadger
  def id
    'elderly'
  end

  def title
    'OAP'
  end

  def description
    "Long-time Hole resident. Been here for #{age_in_days} days. Soon to be put down."
  end

  def metadata
    { age_in_days: age_in_days }
  end

  def eligible?
    user.created_at < Date.new(2018, 07, 01)
  end

  private

  def age_in_days
    @age_in_days ||= (DateTime.now.to_date - user.created_at.to_date).to_i
  end
end

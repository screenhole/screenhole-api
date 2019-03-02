class LongTermUserBadge < BaseBadge
  def id
    'long_term_user'
  end

  def metadata
    { age_in_days: age_in_days }
  end

  def eligible?
    user.created_at < 420.days.ago
  end

  private

  def age_in_days
    @age_in_days ||= (DateTime.now.to_date - user.created_at.to_date).to_i
  end
end

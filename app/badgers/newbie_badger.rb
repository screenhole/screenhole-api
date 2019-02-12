class NewbieBadger < BaseBadger
  def id
    'newbie'
  end

  def title
    'Newbie'
  end

  def description
    'New here! Welcome!'
  end

  def metadata
    { age_in_days: age_in_days }
  end

  def eligible?
    age_in_days <= 7
  end

  private

  def age_in_days
    @age_in_days ||= (DateTime.now.to_date - user.created_at.to_date).to_i
  end
end

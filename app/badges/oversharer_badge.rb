class OversharerBadge < BaseBadge
  def id
    'oversharer'
  end

  def title
    'Oversharer'
  end

  def description
    "OH HELL YEAH! #{grab_count} GRABS!"
  end

  def metadata
    { grab_count: grab_count }
  end

  def eligible?
    grab_count > 100
  end

  private

  def grab_count
    @grab_count ||= user.grabs.count
  end
end

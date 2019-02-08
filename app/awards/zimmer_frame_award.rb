class ZimmerFrameAward < BaseAward
  def id
    'zimmer_frame'
  end

  def title
    'Zimmer Frame'
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
    @age_in_days ||= (Date.now - user.created_at).to_i
  end
end

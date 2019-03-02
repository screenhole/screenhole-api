class NiceBadge < BaseBadge
  NICE_START = 69.freeze
  NICE_END = 71.freeze

  def id
    'nice'
  end

  def metadata
    {
      grab_count: grab_count,
      chomment_count: chomment_count
    }
  end

  def eligible?
    grab_count.between?(NICE_START, NICE_END) || chomment_count.between?(NICE_START, NICE_END)
  end

  private

  def grab_count
    @grab_count ||= user.grabs.count
  end

  def chomment_count
    @chomment_count ||= user.chomments.count
  end
end

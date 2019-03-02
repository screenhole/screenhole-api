class ManyGrabsBadge < BaseBadge
  def id
    'many_grabs'
  end

  def metadata
    { grab_count: grab_count }
  end

  def eligible?
    grab_count > 420
  end

  private

  def grab_count
    @grab_count ||= user.grabs.count
  end
end

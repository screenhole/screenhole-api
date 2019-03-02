class ManyChommentsBadge < BaseBadge
  def id
    'many_chomments'
  end

  def metadata
    { chomment_count: chomment_count }
  end

  def eligible?
    chomment_count > 420
  end

  private

  def chomment_count
    @chomment_count ||= user.chomments.count
  end
end

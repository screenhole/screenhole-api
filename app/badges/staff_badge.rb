class StaffBadge < BaseBadge
  def id
    'staff'
  end

  def metadata
    {}
  end

  def eligible?
    user.is_staff?
  end
end

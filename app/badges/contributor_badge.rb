class ContributorBadge < BaseBadge
  LEGENDS = [
    'pasquale',
    'jacob',
    'aleks',
    'wojtek',
    'josh',
    'boop'
  ].freeze

  def id
    'contributor'
  end

  def metadata
    {}
  end

  def eligible?
    LEGENDS.include?(user.username)
  end
end

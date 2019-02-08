class ChatterboxAward < BaseAward
  def id
    'chatterbox'
  end

  def title
    'Chatterbox'
  end

  def description
    "Likes to talk. Has posted #{chomment_count} chomments."
  end

  def metadata
    { chomment_count: chomment_count }
  end

  def eligible?
    chomment_count > 100
  end

  private

  def chomment_count
    @chomment_count ||= user.chomments.count
  end
end

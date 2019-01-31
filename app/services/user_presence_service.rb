class UserPresenceService
  SET_KEY = 'sup' # screenhole user presence

  def initialize(id:)
    @id = id.to_s
  end

  def appear!
    redis.sadd(SET_KEY, id)
  end

  def disappear!
    redis.srem(SET_KEY, id)
  end

  def present?
    redis.sismember(SET_KEY, id)
  end

  private

  attr_reader :id

  def redis
    @redis ||= Redis.current
  end
end

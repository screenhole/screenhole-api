class UserPresence
  def initialize(user_or_user_id, redis_client = Redis.current)
    @redis_client = redis_client

    if user_or_user_id.respond_to?(:id)
      @user_id = user_or_user_id.id
      return
    end

    @user_id = user_or_user_id
  end

  def present!
    redis_client.sadd(REDIS_SET_NAME, user_id)
  end

  def gone!
    redis_client.srem(REDIS_SET_NAME, user_id)
  end

  def present?
    redis_client.sismember(REDIS_SET_NAME, user_id)
  end

  private

  attr_reader :user_id, :redis_client

  REDIS_SET_NAME = ENV.fetch('USER_PRESENCE_REDIS_KEY', 'user_presence').freeze
  private_constant :REDIS_SET_NAME
end

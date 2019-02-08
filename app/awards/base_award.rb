class BaseAward
  def initialize(user)
    @user = user
  end

  def id
    raise NotImplementedError, 'Implement #id in a child class'
  end

  def title
    raise NotImplementedError, 'Implement #title in a child class'
  end

  def description
    raise NotImplementedError, 'Implement #description in a child class'
  end

  def metadata
    raise NotImplementedError, 'Implement #metadata in a child class'
  end

  def eligible?
    raise NotImplementedError, 'Implement #eligible? in a child class'
  end

  private

  attr_reader :user
end

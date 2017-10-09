class User < ApplicationRecord
  validates_uniqueness_of :username
  validates_presence_of :username

  has_secure_password

  has_many :shots

  def self.from_token_request(request)
    username = request.params["auth"] && request.params["auth"]["username"]
    self.find_by(username: username)
  end
end

class Chomment < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :user

  validates_presence_of :message
end

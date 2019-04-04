module Admin
  class UsersController < Admin::ApplicationController
    def find_resource(param)
      User.find_by_hashid!(param)
    end
  end
end

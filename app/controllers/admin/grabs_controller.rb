module Admin
  class GrabsController < Admin::ApplicationController
    def find_resource(param)
      Grab.find_by_hashid!(param)
    end
  end
end

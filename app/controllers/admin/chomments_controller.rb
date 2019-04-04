module Admin
  class ChommentsController < Admin::ApplicationController
    def find_resource(param)
      Chomment.find_by_hashid!(param)
    end
  end
end

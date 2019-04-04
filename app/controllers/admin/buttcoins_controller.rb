module Admin
  class ButtcoinsController < Admin::ApplicationController
    def find_resource(param)
      Buttcoin.find_by_hashid!(param)
    end
  end
end

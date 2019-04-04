module Admin
  class MemosController < Admin::ApplicationController
    def find_resource(param)
      Memo.find_by_hashid!(param)
    end
  end
end

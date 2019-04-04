module Admin
  class NotesController < Admin::ApplicationController
    def find_resource(param)
      Note.find_by_hashid!(param)
    end
  end
end

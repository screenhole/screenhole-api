module Admin
  class InvitesController < Admin::ApplicationController
    def find_resource(param)
      Invite.find_by_hashid!(param)
    end
  end
end

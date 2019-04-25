module ApplicationCable
  class Channel < ActionCable::Channel::Base
    private

    def channel_name(prefix)
      hole ? hole.cable_channel_name(prefix) : "#{prefix}_messages"
    end

    def hole
      return nil if params[:hole].blank?

      Hole.find_by_subdomain(params[:hole])
    end
  end
end

ActiveModelSerializers.config.adapter = :json

# shut the fuck up!
ActiveSupport::Notifications.unsubscribe(ActiveModelSerializers::Logging::RENDER_EVENT)

Rails.application.config.middleware.insert_after Rack::ETag, Warden::Manager do |manager|
  manager.failure_app = GraphqlController

  Warden::Manager.serialize_into_session(&:id)

  Warden::Manager.serialize_from_session do |id|
    User.find(id)
  end
end

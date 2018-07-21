Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO

Rails.application.eager_load!
Mongoid::Tasks::Database.create_indexes

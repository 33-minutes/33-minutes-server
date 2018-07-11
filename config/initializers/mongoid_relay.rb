GraphQL::Relay::BaseConnection.register_connection_implementation(
  Mongoid::Association::Referenced::HasMany::Targets::Enumerable, GraphQL::Relay::MongoRelationConnection
)

GraphQL::Relay::BaseConnection.register_connection_implementation(
  Mongoid::Criteria, GraphQL::Relay::MongoRelationConnection
)

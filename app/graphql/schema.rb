Schema = GraphQL::Schema.define do
  query Types::QueryType
  mutation Types::MutationType
end

GraphQL::Errors.configure(Schema) do
  rescue_from Mongoid::Errors::DocumentNotFound do
    nil
  end

  rescue_from Mongoid::Errors::Validations do |e|
    error_messages = e.record.errors.full_messages.join("\n")
    GraphQL::ExecutionError.new "Validation failed: #{error_messages}"
  end

  rescue_from StandardError do |e|
    GraphQL::ExecutionError.new e.message
  end
end

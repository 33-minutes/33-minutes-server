Types::DateType = GraphQL::ScalarType.define do
  name 'Date'

  coerce_input ->(value, _ctx) { Time.zone.parse(value).to_date }
  coerce_result ->(value, _ctx) { value.iso8601 }
end

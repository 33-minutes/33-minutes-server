Types::GeoCoordinates = GraphQL::ScalarType.define do
  name 'GeoCoordinates'
  description 'Geo coordinate, latitude followed by longitude.'

  coerce_input ->(value, _ctx) { Geo::Coord.parse(value) }
  coerce_result ->(value, _ctx) { value.to_s }
end

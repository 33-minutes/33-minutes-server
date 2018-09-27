Types::GeoCoordinates = GraphQL::ScalarType.define do
  name 'GeoCoordinates'
  description 'Geo coordinate, latitude followed by longitude.'

  coerce_input ->(value, _ctx) {
    case value
    when Array
      Geo::Coord.new(value[0], value[1])
    else
      Geo::Coord.parse(value)
    end
  }

  coerce_result ->(value, _ctx) { [value.y, value.x] }
end

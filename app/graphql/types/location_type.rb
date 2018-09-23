Types::LocationType = GraphQL::ObjectType.define do
  name 'Location'
  description 'A geo location.'

  field :latitude, !types.Float, 'Lat.', property: :x
  field :longitude, !types.Float, 'Lon.', property: :y
end

Types::LocationType = GraphQL::ObjectType.define do
  name 'Location'
  description 'A geo location.'

  field :longitude, !types.Float, 'Longitude.', property: :x
  field :latitude, !types.Float, 'Latitude.', property: :y
end

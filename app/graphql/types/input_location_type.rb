Types::InputLocationType = GraphQL::InputObjectType.define do
  name 'InputLocation'
  description 'A geo location.'

  argument :latitude, !types.Float, 'Lat.'
  argument :longitude, !types.Float, 'Lon.'
end

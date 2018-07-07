Types::UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'A user.'

  field :id, types.ID, 'User ID.'
  field :name, types.String, 'User full name.'
  field :email, types.String, 'User email.'
  field :created_at, Types::DateTimeType, 'Account creation date.'
end

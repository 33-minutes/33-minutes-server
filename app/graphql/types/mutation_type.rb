Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createUser, field: Mutations::CreateUserMutation.field
  field :login, field: Mutations::LoginMutation.field
  field :logout, field: Mutations::LogoutMutation.field

  field :createMeeting, field: Mutations::CreateMeetingMutation.field
end

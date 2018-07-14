Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  field :createUser, field: Mutations::CreateUserMutation.field
  field :updateUser, field: Mutations::UpdateUserMutation.field
  field :deleteUser, field: Mutations::DeleteUserMutation.field

  field :login, field: Mutations::LoginMutation.field
  field :logout, field: Mutations::LogoutMutation.field

  field :createMeeting, field: Mutations::CreateMeetingMutation.field
  field :deleteMeeting, field: Mutations::DeleteMeetingMutation.field
  field :updateMeeting, field: Mutations::UpdateMeetingMutation.field
end

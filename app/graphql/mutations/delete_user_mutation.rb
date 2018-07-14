Mutations::DeleteUserMutation = GraphQL::Relay::Mutation.define do
  name 'deleteUser'

  return_field :deletedId, !types.ID

  resolve ->(_object, _inputs, ctx) {
    user = ctx[:current_user]
    if user
      user.destroy!
      ctx[:warden].logout
      {
        deletedId: user.id
      }
    else
      GraphQL::ExecutionError.new('Not logged in.')
    end
  }
end

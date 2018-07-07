Mutations::LogoutMutation = GraphQL::Relay::Mutation.define do
  name 'logout'

  return_field :user, Types::UserType

  resolve ->(_object, _inputs, ctx) {
    if ctx[:current_user]
      ctx[:warden].logout
      { user: ctx[:current_user] }
    else
      GraphQL::ExecutionError.new('Not logged in.')
    end
  }
end

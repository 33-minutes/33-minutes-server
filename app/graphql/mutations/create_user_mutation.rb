Mutations::CreateUserMutation = GraphQL::Relay::Mutation.define do
  name 'createUser'

  input_field :email, !types.String
  input_field :password, !types.String
  input_field :name, !types.String

  return_field :user, Types::UserType

  resolve ->(_object, inputs, ctx) {
    user = User.create!(
      email: inputs[:email],
      name: inputs[:name],
      password: inputs[:password]
    )

    ctx[:warden].set_user(user)
    { user: user }
  }
end

Mutations::LoginMutation = GraphQL::Relay::Mutation.define do
  name 'login'

  input_field :email, !types.String
  input_field :password, !types.String

  return_field :user, Types::UserType

  resolve ->(_object, inputs, ctx) {
    user = User.where(email: inputs[:email]).first

    if user && user.authenticate(inputs[:password])
      ctx[:warden].set_user(user)
      { user: user }
    else
      GraphQL::ExecutionError.new('Incorrect email or password.')
    end
  }
end

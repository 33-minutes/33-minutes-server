Mutations::UpdateUserMutation = GraphQL::Relay::Mutation.define do
  name 'updateUser'

  input_field :name, types.String
  input_field :email, types.String
  input_field :password, types.String
  input_field :passwordConfirmation, types.String
  input_field :weeklyMeetingBudget, types.Float

  return_field :user, Types::UserType

  resolve ->(_object, inputs, ctx) {
    user = ctx[:current_user]
    if user
      data = {}
      data[:name] = inputs[:name] if inputs.key?(:name)
      data[:email] = inputs[:email] if inputs.key?(:email)
      data[:weekly_meeting_budget] = inputs[:weeklyMeetingBudget] if inputs.key?(:weeklyMeetingBudget)
      if inputs.key?(:password) || inputs.key?(:passwordConfirmation)
        data[:password] = inputs[:password]
        return GraphQL::ExecutionError.new("Passwords don't match.") unless inputs[:password] == inputs[:passwordConfirmation]
      end
      user.update_attributes!(data)
      { user: user }
    else
      GraphQL::ExecutionError.new('Not logged in.')
    end
  }
end

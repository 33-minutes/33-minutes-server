Mutations::DeleteMeetingMutation = GraphQL::Relay::Mutation.define do
  name 'deleteMeeting'

  input_field :id, !types.ID

  return_field :deletedId, !types.ID

  resolve ->(_object, inputs, ctx) {
    user = ctx[:current_user]
    if user
      meeting = user.meetings.find(inputs[:id])
      if meeting
        meeting.destroy!
        {
          deletedId: meeting.id
        }
      end
    else
      GraphQL::ExecutionError.new('Not logged in.')
    end
  }
end

Mutations::UpdateMeetingMutation = GraphQL::Relay::Mutation.define do
  name 'updateMeeting'

  input_field :id, !types.ID
  input_field :title, types.String
  input_field :started, Types::DateTimeType
  input_field :finished, Types::DateTimeType

  return_field :meeting, Types::MeetingType

  resolve ->(_object, inputs, ctx) {
    user = ctx[:current_user]
    if user
      meeting = user.meetings.find(inputs[:id])
      if meeting
        data = {}
        data[:title] = inputs[:title] if inputs.key?(:title)
        data[:started_at] = inputs[:started] if inputs.key?(:started)
        data[:finished_at] = inputs[:finished] if inputs.key?(:finished)
        data[:location] = inputs[:location].to_h if inputs.key?(:location)

        meeting.update_attributes!(data)
        { meeting: meeting }
      end
    else
      GraphQL::ExecutionError.new('Not logged in.')
    end
  }
end

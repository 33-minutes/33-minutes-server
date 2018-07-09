Mutations::CreateMeetingMutation = GraphQL::Relay::Mutation.define do
  name 'createMeeting'

  input_field :title, types.String
  input_field :started, !Types::DateTimeType
  input_field :finished, !Types::DateTimeType

  return_field :meeting, Types::MeetingType
  return_field :meetingsConnection, Types::MeetingType.connection_type
  return_field :meetingEdge, Types::MeetingType.edge_type

  resolve ->(_object, inputs, ctx) {
    user = ctx[:current_user]
    if user
      meeting = user.meetings.create!(
        title: inputs[:title],
        started_at: inputs[:started],
        finished_at: inputs[:finished]
      )

      range_add = GraphQL::Relay::RangeAdd.new(
        parent: user,
        collection: user.meetings,
        item: meeting,
        context: ctx
      )

      {
        meeting: meeting,
        meetingsConnection: range_add.connection,
        meetingEdge: range_add.edge
      }
    else
      GraphQL::ExecutionError.new('Not logged in.')
    end
  }
end

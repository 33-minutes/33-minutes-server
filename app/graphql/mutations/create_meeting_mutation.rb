Mutations::CreateMeetingMutation = GraphQL::Relay::Mutation.define do
  name 'createMeeting'

  input_field :title, types.String
  input_field :started, !Types::DateTimeType
  input_field :finished, !Types::DateTimeType
  input_field :location, Types::InputLocationType

  return_field :meeting, Types::MeetingType
  return_field :meetingsConnection, Types::MeetingType.connection_type
  return_field :meetingEdge, Types::MeetingType.edge_type

  resolve ->(_object, inputs, ctx) {
    user = ctx[:current_user]

    if user
      data = {}

      data[:title] = inputs[:title]
      data[:started_at] = inputs[:started]
      data[:finished_at] = inputs[:finished]
      data[:location] = inputs[:location].to_h if inputs[:location]

      meeting = user.meetings.create!(data)

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

Mutations::CreateMeetingMutation = GraphQL::Relay::Mutation.define do
  name 'createMeeting'

  input_field :title, types.String
  input_field :started, !Types::DateTimeType
  input_field :finished, !Types::DateTimeType

  return_field :meeting, Types::MeetingType

  resolve ->(_object, inputs, ctx) {
    if ctx[:current_user]
      meeting = ctx[:current_user].meetings.create!(
        title: inputs[:title],
        started_at: inputs[:started],
        finished_at: inputs[:finished]
      )

      { meeting: meeting }
    else
      GraphQL::ExecutionError.new('Not logged in.')
    end
  }
end

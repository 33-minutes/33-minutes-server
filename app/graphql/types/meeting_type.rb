Types::MeetingType = GraphQL::ObjectType.define do
  name 'Meeting'
  description 'A recorded meeting.'

  field :id, types.ID, 'Meeting ID.'
  field :title, types.String, 'Meeting title.'
  field :started, Types::DateTimeType, 'The time at which this meeting started.', property: :started_at
  field :finished, Types::DateTimeType, 'The time at which this meeting ended.', property: :finished_at
  field :user, Types::UserType, 'Owner of this meeting.'
end

Types::WeeklyMeetingsType = GraphQL::ObjectType.define do
  name 'WeeklyMeetings'
  description 'Weekly user meetings.'

  field :id, !types.ID
  field :year, !types.Int, 'Year.'
  field :week, !types.Int, 'Week.'
  field :weekStart, Types::DateType, 'Number of seconds spent in meetings.'
  field :count, !types.Int, 'Number of meetings.'
  field :duration, !types.Int, 'Number of seconds spent in meetings.'

  field :user, Types::UserType, 'Owner of these meetings.'
end

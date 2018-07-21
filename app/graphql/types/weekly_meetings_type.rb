Types::WeeklyMeetingsType = GraphQL::ObjectType.define do
  name 'WeeklyMeetings'
  description 'Weekly user meetings.'

  field :year, types.Int, 'Year.' do
    resolve ->(obj, _args, _ctx) {
      obj['_id']['year']
    }
  end

  field :week, types.Int, 'Week.' do
    resolve ->(obj, _args, _ctx) {
      obj['_id']['week']
    }
  end

  field :count, types.Int, 'Number of meetings.' do
    resolve ->(obj, _args, _ctx) {
      obj['count']
    }
  end

  field :duration, types.Int, 'Number of seconds spent in meetings.' do
    resolve ->(obj, _args, _ctx) {
      obj['duration'] / 1000
    }
  end

  field :user, Types::UserType, 'Owner of these meetings.'
end

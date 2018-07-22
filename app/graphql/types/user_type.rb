Types::UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'A user.'

  field :id, types.ID, 'User ID.'
  field :name, types.String, 'User full name.'
  field :email, types.String, 'User email.'
  field :created, Types::DateTimeType, 'Account creation date.'
  field :weeklyMeetingBudget, types.Float, 'Weekly meeting budget in hours.', property: :weekly_meeting_budget

  field :meeting, !Types::MeetingType do
    argument :id, !types.String
    description 'Get a meeting by ID.'
    resolve ->(obj, args, _ctx) {
      obj.meetings.where(_id: args[:id]).first
    }
  end

  connection :meetings, Types::MeetingType.connection_type do
    resolve ->(obj, _, _) {
      obj.meetings.desc(:_id)
    }
  end

  connection :weeklyMeetings, Types::WeeklyMeetingsType.connection_type do
    resolve ->(obj, _, _) {
      obj.weekly_meetings.map do |weekly_meeting|
        OpenStruct.new(
          id: "#{weekly_meeting['_id']['year']}-#{weekly_meeting['_id']['week']}",
          year: weekly_meeting['_id']['year'],
          week: weekly_meeting['_id']['week'],
          weekStart: Date.commercial(weekly_meeting['_id']['year'], weekly_meeting['_id']['week'], 1),
          count: weekly_meeting['count'],
          duration: weekly_meeting['duration'] / 1000
        )
      end
    }
  end
end

Types::UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'A user.'

  field :id, types.ID, 'User ID.'
  field :name, types.String, 'User full name.'
  field :email, types.String, 'User email.'
  field :created_at, Types::DateTimeType, 'Account creation date.'

  field :meeting, !Types::MeetingType do
    argument :id, !types.String
    description 'Get a meeting by ID.'
    resolve ->(obj, args, _ctx) {
      obj.meetings.where(_id: args[:id]).first
    }
  end

  field :meetings, -> { !types[Types::MeetingType] }
end

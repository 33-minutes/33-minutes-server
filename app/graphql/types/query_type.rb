Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema. See available queries.'

  field :current_user, !Types::UserType do
    description 'Get current user.'
    resolve ->(_obj, _args, ctx) {
      ctx[:current_user] || GraphQL::ExecutionError.new('Not logged in.')
    }
  end

  field :meeting, !Types::MeetingType do
    argument :id, !types.String
    description 'Get a meeting by ID.'
    resolve ->(_obj, args, ctx) {
      if ctx[:current_user]
        ctx[:current_user].meetings.where(_id: args[:id]).first
      else
        GraphQL::ExecutionError.new('Not logged in.')
      end
    }
  end

  field :meetings, !types[Types::MeetingType] do
    description 'Get current user meetings.'
    resolve ->(_obj, _args, ctx) {
      if ctx[:current_user]
        ctx[:current_user].meetings
      else
        GraphQL::ExecutionError.new('Not logged in.')
      end
    }
  end
end

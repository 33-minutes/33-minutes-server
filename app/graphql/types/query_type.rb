Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema. See available queries.'

  field :user, !Types::UserType do
    description 'Get current user.'
    resolve ->(_obj, _args, ctx) {
      ctx[:current_user] || GraphQL::ExecutionError.new('Not logged in.')
    }
  end
end

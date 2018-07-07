require 'graphlient'

RSpec.shared_context 'Authenticated Client', shared_context: :metadata do
  include_context 'GraphQL Client'

  let(:password) { 'password' }
  let(:current_user) { Fabricate(:user, password: password) }

  let(:login_query) do
    <<-GRAPHQL
      mutation($input: loginInput!) {
        login(input: $input) {
          user {
            id
          }
        }
      }
    GRAPHQL
  end

  before do
    client.execute(
      login_query, input: {
        email: current_user.email,
        password: password
      }
    )
  end
end

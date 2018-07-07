require 'rails_helper'

describe 'Login', type: :request do
  include Warden::Test::Helpers

  include_context 'GraphQL Client'

  let(:login_query) do
    <<-GRAPHQL
      mutation($input: loginInput!) {
        login(input: $input) {
          user {
            id
            email
            name
          }
        }
      }
    GRAPHQL
  end

  let(:query) do
    <<-GRAPHQL
      mutation($input: logoutInput!) {
        logout(input: $input) {
          user {
            id
            email
            name
          }
        }
      }
    GRAPHQL
  end

  let(:user) { Fabricate(:user, password: 'password') }

  context 'logged in' do
    before do
      client.execute(
        login_query, input: {
          email: user.email,
          password: 'password'
        }
      )
    end

    it 'logs out' do
      response = client.execute(
        query, input: {}
      )
      data = response.data.logout
      user = data.user
      expect(user.id).to eq user.id

      expect do
        client.execute(
          query, input: {}
        )
      end.to raise_error Graphlient::Errors::ExecutionError, 'logout: Not logged in.'
    end
  end

  it 'not logged in' do
    expect do
      client.execute(
        query, input: {}
      )
    end.to raise_error Graphlient::Errors::ExecutionError, 'logout: Not logged in.'
  end
end

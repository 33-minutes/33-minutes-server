require 'rails_helper'

describe 'Login', type: :request do
  include_context 'GraphQL Client'

  let(:query) do
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

  let(:user) { Fabricate(:user, password: 'password') }

  it 'returns an user' do
    response = client.execute(
      query, input: {
        email: user.email,
        password: 'password'
      }
    )
    data = response.data.login
    user = data.user
    expect(user.id).to eq user.id
    expect(user.name).to eq user.name
    expect(user.email).to eq user.email
  end

  it 'fails with a wrong password' do
    expect do
      client.execute(
        query, input: {
          email: user.email,
          password: 'invalid'
        }
      )
    end.to raise_error Graphlient::Errors::ExecutionError, 'login: Incorrect email or password.'
  end

  it 'fails with a wrong email' do
    expect do
      client.execute(
        query, input: {
          email: Faker::Internet.email,
          password: 'password'
        }
      )
    end.to raise_error Graphlient::Errors::ExecutionError, 'login: Incorrect email or password.'
  end
end

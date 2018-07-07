require 'rails_helper'

describe 'Create User', type: :request do
  include_context 'GraphQL Client'

  let(:query) do
    <<-GRAPHQL
      mutation($input: createUserInput!) {
        createUser(input: $input) {
          user {
            id
            email
            name
          }
        }
      }
    GRAPHQL
  end

  let(:name) { Faker::Name.name }
  let(:email) { Faker::Internet.email }
  let(:password) { 'password' }

  it 'returns an user' do
    expect do
      response = client.execute(
        query, input: {
          name: name,
          email: email,
          password: password
        }
      )
      data = response.data.create_user
      user = data.user
      expect(user.name).to eq name
      expect(user.email).to eq email
    end.to change(User, :count).by(1)

    user = User.where(email: email).first
    expect(user).to_not be_nil
    expect(user.authenticate(password)).to_not be nil
    expect(user.authenticate('invalid')).to be nil
  end

  context 'with an existing user' do
    let!(:user) { Fabricate(:user) }

    it 'does not create a duplicate user' do
      expect do
        client.execute(
          query, input: {
            name: name,
            email: user.email,
            password: password
          }
        )
      end.to raise_error Graphlient::Errors::ExecutionError, 'createUser: Validation failed: Email Email address already in use.'
    end

    it 'fails with an incorrect email' do
      expect do
        client.execute(
          query, input: {
            name: name,
            email: 'invalid',
            password: password
          }
        )
      end.to raise_error Graphlient::Errors::ExecutionError, 'createUser: Validation failed: Email Please enter a valid email address.'
    end
  end
end

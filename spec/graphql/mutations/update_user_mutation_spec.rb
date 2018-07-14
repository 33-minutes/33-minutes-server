require 'rails_helper'

describe 'Update User', type: :request do
  include_context 'Authenticated Client'

  let(:query) do
    <<-GRAPHQL
      mutation($input: updateUserInput!) {
        updateUser(input: $input) {
          user {
            id
            name
            email
          }
        }
      }
    GRAPHQL
  end

  let(:name) { Faker::Name.name }
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password }

  it 'updates user properties' do
    response = client.execute(
      query, input: {
        name: name,
        email: email
      }
    )
    update_user = response.data.update_user.user
    expect(update_user.name).to eq name
    expect(update_user.email).to eq email

    current_user.reload
    expect(current_user.name).to eq name
    expect(current_user.email).to eq email
  end

  it 'updates user password' do
    response = client.execute(
      query, input: {
        password: password,
        passwordConfirmation: password
      }
    )

    current_user.reload
    expect(current_user.authenticate(password)).to_not be nil
  end

  it 'does not update user password without confirmation' do
    expect do
      client.execute(
        query, input: {
          password: password
        }
      )
    end.to raise_error Graphlient::Errors::ExecutionError, "updateUser: Passwords don't match."
  end

  it 'does not update user password without a valid confirmation' do
    expect do
      client.execute(
        query, input: {
          password: password,
          passwordConfirmation: 'other'
        }
      )
    end.to raise_error Graphlient::Errors::ExecutionError, "updateUser: Passwords don't match."
  end
end

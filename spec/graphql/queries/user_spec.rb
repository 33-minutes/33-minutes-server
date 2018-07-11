require 'rails_helper'

describe 'Current User Query', type: :request do
  context 'unauthenticated' do
    include_context 'GraphQL Client'

    let(:query) do
      <<-GRAPHQL
        query {
          user {
            id
          }
        }
      GRAPHQL
    end

    it 'returns null id' do
      response = client.execute(query)
      user = response.data.user
      expect(user.id).to be nil
    end
  end

  context 'authenticated' do
    include_context 'Authenticated Client'

    let(:query) do
      <<-GRAPHQL
        query {
          user {
            id
            email
          }
        }
      GRAPHQL
    end

    it 'returns the current_user' do
      response = client.execute(query)
      user = response.data.user
      expect(user.id).to eq current_user.id.to_s
    end
  end
end

require 'rails_helper'

describe 'Current User Query', type: :request do
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

  it 'returns an current_user' do
    response = client.execute(query)
    user = response.data.user
    expect(user.id).to eq current_user.id.to_s
  end
end

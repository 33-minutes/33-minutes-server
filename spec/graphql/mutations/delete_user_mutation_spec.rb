require 'rails_helper'

describe 'Delete User', type: :request do
  let(:query) do
    <<-GRAPHQL
      mutation($input: deleteUserInput!) {
        deleteUser(input: $input) {
          deletedId
        }
      }
    GRAPHQL
  end

  context 'logged in' do
    include_context 'Authenticated Client'

    it 'deletes user' do
      expect do
        response = client.execute(
          query, input: {}
        )

        expect(response.data.delete_user.deleted_id).to eq current_user.id.to_s
      end.to change(User, :count).by(-1)

      expect do
        client.execute(
          query, input: {}
        )
      end.to raise_error Graphlient::Errors::ExecutionError, 'deleteUser: Not logged in.'
    end
  end

  context 'not logged in' do
    include_context 'GraphQL Client'

    it 'raises an error' do
      expect do
        client.execute(
          query, input: {}
        )
      end.to raise_error Graphlient::Errors::ExecutionError, 'deleteUser: Not logged in.'
    end
  end
end

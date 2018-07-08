require 'rails_helper'

describe 'Current User Meeting Query', type: :request do
  include_context 'Authenticated Client'

  let(:query) do
    <<-GRAPHQL
      query($id: String!) {
        user {
          meeting(id: $id) {
            id
            title
            started
            finished
          }
        }
      }
    GRAPHQL
  end

  let!(:meeting) { Fabricate(:meeting, user: current_user) }

  it 'returns the meeting' do
    response = client.execute(query, id: meeting.id.to_s)
    meeting = response.data.user.meeting
    expect(meeting.id).to eq meeting.id.to_s
  end
end

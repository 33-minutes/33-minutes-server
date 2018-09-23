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
            location {
              latitude
              longitude
            }
          }
        }
      }
    GRAPHQL
  end

  let!(:meeting) { Fabricate(:meeting, user: current_user) }

  it 'returns the meeting' do
    response = client.execute(query, id: meeting.id.to_s)
    returned_meeting = response.data.user.meeting
    expect(returned_meeting.id).to eq meeting.id.to_s
    expect(returned_meeting.title).to eq meeting.title
    expect(returned_meeting.started).to eq meeting.started_at.utc.iso8601
    expect(returned_meeting.finished).to eq meeting.finished_at.utc.iso8601
    expect(returned_meeting.location.latitude).to eq meeting.location.x
    expect(returned_meeting.location.longitude).to eq meeting.location.y
  end
end

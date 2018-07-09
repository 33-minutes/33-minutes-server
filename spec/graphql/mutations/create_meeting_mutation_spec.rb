require 'rails_helper'

describe 'Create Meeting', type: :request do
  include_context 'Authenticated Client'

  let(:query) do
    <<-GRAPHQL
      mutation($input: createMeetingInput!) {
        createMeeting(input: $input) {
          meeting {
            id
            title
            started
            finished
          },
          meetingEdge {
            node {
              id
            }
          }
        }
      }
    GRAPHQL
  end

  let(:title) { Faker::Company.buzzword }
  let(:started_at) { Faker::Time.backward(1) }
  let(:finished_at) { Time.now }

  it 'returns an meeting' do
    expect do
      response = client.execute(
        query, input: {
          title: title,
          started: started_at,
          finished: finished_at
        }
      )
      meeting = response.data.create_meeting.meeting
      expect(meeting.title).to eq title
      expect(DateTime.parse(meeting.started)).to eq started_at.utc.iso8601
      expect(DateTime.parse(meeting.finished)).to eq finished_at.utc.iso8601

      edge = response.data.create_meeting.meeting_edge
      expect(edge.node.id).to eq meeting.id

      user_meeting = current_user.meetings.first
      expect(user_meeting).to_not be nil
      expect(user_meeting.id.to_s).to eq meeting.id
    end.to change(Meeting, :count).by(1)
  end
end

require 'rails_helper'

describe 'Update Meeting', type: :request do
  include_context 'Authenticated Client'

  let!(:meeting) { Fabricate(:meeting, user: current_user) }

  let(:query) do
    <<-GRAPHQL
      mutation($input: updateMeetingInput!) {
        updateMeeting(input: $input) {
          meeting {
            id
            title
          }
        }
      }
    GRAPHQL
  end

  let(:title) { Faker::Company.buzzword }

  it 'updates the meeting' do
    expect do
      response = client.execute(
        query, input: {
          id: meeting.id.to_s,
          title: title
        }
      )
      update_meeting = response.data.update_meeting.meeting
      expect(update_meeting.title).to eq title
    end.to_not change(Meeting, :count)
    expect(meeting.reload.title).to eq title
  end
end

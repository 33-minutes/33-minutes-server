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
            location
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

  it 'updates location' do
    response = client.execute(
      query, input: {
        id: meeting.id.to_s,
        location: '50.004444, 36.231389'
      }
    )
    update_meeting = response.data.update_meeting.meeting
    expect(update_meeting.location).to eq [50.004444, 36.231389]
    expect(meeting.reload.location.to_a).to eq [50.004444, 36.231389]
  end

  it 'fails with an invalid location' do
    expect do
      client.execute(
        query, input: {
          id: meeting.id.to_s,
          location: 'invalid'
        }
      )
    end.to raise_error Graphlient::Errors::GraphQLError, /location: Could not coerce value "invalid" to GeoCoordinates/
  end
end

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

  context 'updates location' do
    let(:response) do
      client.execute(
        query, input: {
          id: meeting.id.to_s,
          location: location
        }
      )
    end

    let(:updated_meeting) { response.data.update_meeting.meeting }

    context 'string' do
      let(:location) { '50.004444, 36.231389' }

      it 'updates location' do
        expect(updated_meeting.location).to eq [50.004444, 36.231389]
        expect(meeting.reload.location.to_a).to eq [50.004444, 36.231389]
      end
    end

    context 'array' do
      let(:location) { [50.004444, 36.231389] }

      it 'updates location' do
        expect(updated_meeting.location).to eq [50.004444, 36.231389]
        expect(meeting.reload.location.to_a).to eq [50.004444, 36.231389]
      end
    end

    context 'invalid' do
      let(:location) { 'invalid' }
      it 'fails with an invalid location' do
        expect do
          updated_meeting
        end.to raise_error Graphlient::Errors::GraphQLError, /location: Could not coerce value "invalid" to GeoCoordinates/
      end
    end
  end
end

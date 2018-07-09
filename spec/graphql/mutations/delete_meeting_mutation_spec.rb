require 'rails_helper'

describe 'Delete Meeting', type: :request do
  include_context 'Authenticated Client'

  let!(:meeting) { Fabricate(:meeting, user: current_user) }

  let(:query) do
    <<-GRAPHQL
      mutation($input: deleteMeetingInput!) {
        deleteMeeting(input: $input) {
          deletedId
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
          id: meeting.id.to_s
        }
      )
      meeting_id = response.data.delete_meeting.deleted_id
      expect(meeting_id).to eq meeting.id.to_s
    end.to change(Meeting, :count).by(-1)
  end
end

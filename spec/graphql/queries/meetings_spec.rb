require 'rails_helper'

describe 'Current User Meetings Query', type: :request do
  include_context 'Authenticated Client'

  let(:query) do
    <<-GRAPHQL
      query {
        meetings {
          id
          title
          started
          finished
        }
      }
    GRAPHQL
  end

  let!(:meetings) { 3.times { Fabricate(:meeting, user: current_user) } }

  it 'returns the meetings' do
    meetings = client.execute(query).data.meetings
    expect(meetings.size).to eq 3
  end
end

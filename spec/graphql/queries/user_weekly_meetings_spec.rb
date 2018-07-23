require 'rails_helper'

describe 'Current User Weekly Meetings Query', type: :request do
  include_context 'Authenticated Client'

  before do
    Timecop.travel('2018/04/02 12:00PM EST')

    7.times do |i|
      Fabricate(:meeting, user: current_user,
                          started_at: ::Date.today - i,
                          finished_at: ::Date.today - i + 1.hour)
    end
  end

  let(:query) do
    <<-GRAPHQL
      query {
        user {
          weeklyMeetings {
            edges {
              node {
                id
                week
                weekStart
                year
                count
                duration
              },
              cursor
            },
            pageInfo {
              hasNextPage,
              hasPreviousPage,
              endCursor
            }
          }
        }
      }
    GRAPHQL
  end

  it 'returns weekly meetings' do
    meetings = client.execute(query).data.user.weekly_meetings.edges.map(&:node)
    expect(meetings.map(&:to_h)).to eq [
      { 'id' => '2018-14', 'week' => 14, 'weekStart' => '2018-04-02', 'year' => 2018, 'count' => 1, 'duration' => 3600 },
      { 'id' => '2018-13', 'week' => 13, 'weekStart' => '2018-03-26', 'year' => 2018, 'count' => 6, 'duration' => 21_600 }
    ]
  end
end

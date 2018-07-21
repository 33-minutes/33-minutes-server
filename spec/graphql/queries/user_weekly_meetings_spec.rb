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
          weekly_meetings {
            edges {
              node {
                week
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
      { 'week' => 12, 'year' => 2018, 'count' => 5, 'duration' => 18_000 },
      { 'week' => 13, 'year' => 2018, 'count' => 2, 'duration' => 7200 }
    ]
  end
end

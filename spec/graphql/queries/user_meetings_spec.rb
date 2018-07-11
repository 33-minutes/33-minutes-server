require 'rails_helper'

describe 'Current User Meetings Query', type: :request do
  include_context 'Authenticated Client'

  let!(:meetings) { 3.times { Fabricate(:meeting, user: current_user) } }

  context 'all at once' do
    let(:query) do
      <<-GRAPHQL
        query {
          user {
            meetings {
              edges {
                node {
                  id
                  title,
                  started,
                  finished
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

    it 'returns meetings in descending order' do
      meetings = client.execute(query).data.user.meetings.edges.map(&:node)
      expect(meetings.size).to eq 3
      expect(meetings.map(&:id)).to eq current_user.meetings.desc(:id).pluck(:id).map(&:to_s)
    end
  end

  context 'by 2' do
    let(:query) do
      <<-GRAPHQL
        query($first: Int, $after: String) {
          user {
            meetings(first: $first, after: $after) {
              edges {
                node {
                  id
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

    it 'relay-paginates through meetings' do
      all = []
      cursor = nil
      loop do
        page_meetings = client.execute(query, first: 2, after: cursor).data.user.meetings
        edges = page_meetings.edges
        expect(edges.size).to be <= 2
        all.concat(edges.map(&:node))
        cursor = page_meetings.page_info.end_cursor
        break unless cursor
      end
      expect(all.map(&:id).sort).to eq current_user.meetings.map(&:id).map(&:to_s).sort
    end
  end
end

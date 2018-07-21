require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { Fabricate(:user) }
  context 'fixed time' do
    before do
      Timecop.travel('2018/04/02 12:00PM EST')
    end
    context 'with 7 days of 2 meetings a day' do
      before do
        7.times do |i|
          Fabricate(:meeting, user: user,
                              started_at: ::Date.today - i,
                              finished_at: (::Date.today - i) + 1.hour)
        end
      end
      context '#weekly_meetings' do
        let(:meetings) { user.weekly_meetings.to_a }
        it 'aggregates by week' do
          expect(meetings).to eq [
            { '_id' => { 'year' => 2018, 'week' => 12 }, 'count' => 5, 'duration' => 18_000_000 },
            { '_id' => { 'year' => 2018, 'week' => 13 }, 'count' => 2, 'duration' => 7_200_000 }
          ]
        end
      end
    end
  end
end

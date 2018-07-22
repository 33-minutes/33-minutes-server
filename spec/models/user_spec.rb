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
          Fabricate(:meeting, user: user, started_at: ::Date.today - i, finished_at: (::Date.today - i) + 1.hour)
        end
      end
      context '#weekly_meetings.without_gaps' do
        let(:meetings) { user.weekly_meetings.without_gaps }
        it 'aggregates by week' do
          expect(meetings.map(&:to_h)).to eq [
            { id: '2018-13', year: 2018, week: 13, weekStart: Date.parse('26-Mar-2018'), count: 2, duration: 7_200 },
            { id: '2018-12', year: 2018, week: 12, weekStart: Date.parse('19-Mar-2018'), count: 5, duration: 18_000 }
          ]
        end
        context 'with another user' do
          before do
            Fabricate(:meeting, user: Fabricate(:user))
          end
          it 'aggregates only meetings by this user' do
            expect(meetings.map(&:to_h)).to eq [
              { id: '2018-13', year: 2018, week: 13, weekStart: Date.parse('26-Mar-2018'), count: 2, duration: 7_200 },
              { id: '2018-12', year: 2018, week: 12, weekStart: Date.parse('19-Mar-2018'), count: 5, duration: 18_000 }
            ]
          end
        end
        context 'with a gap' do
          before do
            Fabricate(:meeting, user: user, started_at: ::Date.today - 28, finished_at: (::Date.today - 28) + 1.hour)
            Fabricate(:meeting, user: user, started_at: ::Date.parse('27-Dec-2017'), finished_at: ::Date.parse('27-Dec-2017') + 2.hours)
          end
          it 'fills gaps across years' do
            expect(meetings.map(&:to_h)).to eq [
              { id: '2018-13', year: 2018, week: 13, weekStart: Date.parse('26-Mar-2018'), count: 2, duration: 7_200 },
              { id: '2018-12', year: 2018, week: 12, weekStart: Date.parse('19-Mar-2018'), count: 5, duration: 18_000 },
              { id: '2018-11', year: 2018, week: 11, weekStart: Date.parse('12-Mar-2018'), count: 0, duration: 0 },
              { id: '2018-10', year: 2018, week: 10, weekStart: Date.parse('5-Mar-2018'), count: 0, duration: 0 },
              { id: '2018-09', year: 2018, week: 9, weekStart: Date.parse('26-Feb-2018'), count: 1, duration: 3_600 },
              { id: '2018-08', year: 2018, week: 8, weekStart: Date.parse('19-Feb-2018'), count: 0, duration: 0 },
              { id: '2018-07', year: 2018, week: 7, weekStart: Date.parse('12-Feb-2018'), count: 0, duration: 0 },
              { id: '2018-06', year: 2018, week: 6, weekStart: Date.parse('5-Feb-2018'), count: 0, duration: 0 },
              { id: '2018-05', year: 2018, week: 5, weekStart: Date.parse('29-Jan-2018'), count: 0, duration: 0 },
              { id: '2018-04', year: 2018, week: 4, weekStart: Date.parse('22-Jan-2018'), count: 0, duration: 0 },
              { id: '2018-03', year: 2018, week: 3, weekStart: Date.parse('15-Jan-2018'), count: 0, duration: 0 },
              { id: '2018-02', year: 2018, week: 2, weekStart: Date.parse('8-Jan-2018'), count: 0, duration: 0 },
              { id: '2018-01', year: 2018, week: 1, weekStart: Date.parse('1-Jan-2018'), count: 0, duration: 0 },
              { id: '2017-52', year: 2017, week: 52, weekStart: Date.parse('25-Dec-2017'), count: 1, duration: 7_200 }
            ]
          end
        end
      end
    end
  end
end

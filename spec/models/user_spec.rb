require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { Fabricate(:user) }
  context '#user.weekly_meetings.without_gaps' do
    before do
      Timecop.travel('2018/01/27 12:00PM EST') # Saturday
    end
    subject do
      user.weekly_meetings.without_gaps.map(&:to_h)
    end
    context 'without meetings' do
      it 'returns current week' do
        expect(subject).to eq [
          { id: '2018-04', year: 2018, week: 4, weekStart: Date.parse('22-Jan-2018'), count: 0, duration: 0 }
        ]
      end
    end
    context 'with meetings last week' do
      let(:last_week_dt) { Time.parse('19-Jan-2018 3:00PM EST') }
      before do
        Fabricate(:meeting, user: user, started_at: last_week_dt, finished_at: last_week_dt + 1.hour)
      end
      it 'inserts the missing week' do
        expect(subject).to eq [
          { id: '2018-04', year: 2018, week: 4, weekStart: Date.parse('22-Jan-2018'), count: 0, duration: 0 },
          { id: '2018-03', year: 2018, week: 3, weekStart: Date.parse('15-Jan-2018'), count: 1, duration: 3_600 }
        ]
      end
    end
    context 'with 7 days of 2 meetings a day' do
      before do
        7.times do |i|
          Fabricate(:meeting, user: user, started_at: Date.today - i, finished_at: (Date.today - i) + 1.hour)
        end
      end
      it 'aggregates by week' do
        expect(subject).to eq [
          { id: '2018-04', year: 2018, week: 4, weekStart: Date.parse('22-Jan-2018'), count: 6, duration: 21_600 },
          { id: '2018-03', year: 2018, week: 3, weekStart: Date.parse('15-Jan-2018'), count: 1, duration: 3_600 }
        ]
      end
      context 'with another user' do
        before do
          Fabricate(:meeting, user: Fabricate(:user))
        end
        it 'aggregates only meetings by this user' do
          expect(subject).to eq [
            { id: '2018-04', year: 2018, week: 4, weekStart: Date.parse('22-Jan-2018'), count: 6, duration: 21_600 },
            { id: '2018-03', year: 2018, week: 3, weekStart: Date.parse('15-Jan-2018'), count: 1, duration: 3_600 }
          ]
        end
      end
      context 'with a gap overlapping a year' do
        before do
          Fabricate(:meeting, user: user, started_at: Date.parse('27-Dec-2017'), finished_at: Date.parse('27-Dec-2017') + 2.hours)
        end
        it 'fills the gap' do
          expect(subject).to eq [
            { id: '2018-04', year: 2018, week: 4, weekStart: Date.parse('22-Jan-2018'), count: 6, duration: 21_600 },
            { id: '2018-03', year: 2018, week: 3, weekStart: Date.parse('15-Jan-2018'), count: 1, duration: 3_600 },
            { id: '2018-02', year: 2018, week: 2, weekStart: Date.parse('8-Jan-2018'), count: 0, duration: 0 },
            { id: '2018-01', year: 2018, week: 1, weekStart: Date.parse('1-Jan-2018'), count: 0, duration: 0 },
            { id: '2017-52', year: 2017, week: 52, weekStart: Date.parse('25-Dec-2017'), count: 1, duration: 7_200 }
          ]
        end
      end
      context 'with a missing month' do
        before do
          Fabricate(:meeting, user: user, started_at: Time.parse('07-Jan-2018 11:00AM EST'), finished_at: Time.parse('07-Jan-2018 1:00PM EST'))
        end
        it 'fills gap' do
          expect(subject).to eq [
            { id: '2018-04', year: 2018, week: 4, weekStart: Date.parse('22-Jan-2018'), count: 6, duration: 21_600 },
            { id: '2018-03', year: 2018, week: 3, weekStart: Date.parse('15-Jan-2018'), count: 1, duration: 3_600 },
            { id: '2018-02', year: 2018, week: 2, weekStart: Date.parse('8-Jan-2018'), count: 0, duration: 0 },
            { id: '2018-01', year: 2018, week: 1, weekStart: Date.parse('1-Jan-2018'), count: 1, duration: 7_200 }
          ]
        end
      end
    end
  end
end

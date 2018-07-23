class WeeklyMeetings
  attr_reader :aggregation

  def initialize(user)
    @aggregation = user.meetings.collection.aggregate(
      [
        { '$match' => { user_id: user.id } },
        {
          '$group' => {
            _id: {
              year: { '$year' => '$started_at' },
              week: { '$isoWeek' => '$started_at' }
            },
            count: { '$sum' => 1 },
            duration: { '$sum' => { '$subtract' => ['$finished_at', '$started_at'] } }
          }
        },
        { '$sort' => { _id: -1 } }
      ]
    )
  end

  def structured_results
    Hash[aggregation.map do |row|
      struct = WeeklyMeetings.row_to_struct(row)
      [struct.weekStart, struct]
    end]
  end

  def without_gaps
    results = []

    data = structured_results

    week_start = Time.now.utc.beginning_of_week.to_date
    last_week_start = !data.empty? ? data.values[-1].weekStart : week_start

    while week_start >= last_week_start
      row = data[week_start] || WeeklyMeetings.blank_struct(week_start)
      results << row
      week_start -= 1.week
    end

    results
  end

  # aggregation row to a struct
  def self.row_to_struct(row)
    year = row['_id']['year']
    week = row['_id']['week']
    count = row['count']
    duration = row['duration'] / 1000

    week_start = Date.commercial(year, week, 1)

    OpenStruct.new(
      id: week_start.strftime('%Y-%W'),
      year: year,
      week: week,
      weekStart: week_start,
      count: count,
      duration: duration
    )
  end

  # empty row
  def self.blank_struct(week_start)
    OpenStruct.new(
      id: week_start.strftime('%Y-%W'),
      year: week_start.year,
      week: week_start.cweek,
      weekStart: week_start,
      count: 0,
      duration: 0
    )
  end
end

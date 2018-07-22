class WeeklyMeetings < SimpleDelegator
  def initialize(user)
    super user.meetings.collection.aggregate(
      [
        { '$match' => { user_id: user.id } },
        {
          '$group' => {
            _id: {
              year: { '$year' => '$started_at' },
              week: { '$week' => '$started_at' }
            },
            count: { '$sum' => 1 },
            duration: { '$sum' => { '$subtract' => ['$finished_at', '$started_at'] } }
          }
        },
        { '$sort' => { _id: -1 } }
      ]
    )
  end

  def without_gaps
    results = []
    data = to_a
    data.each_with_index do |row, index|
      week_start = Date.commercial(row['_id']['year'], row['_id']['week'], 1)

      result = OpenStruct.new(
        id: week_start.strftime('%Y-%W'),
        year: row['_id']['year'],
        week: row['_id']['week'],
        weekStart: week_start,
        count: row['count'],
        duration: row['duration'] / 1000
      )

      results << result

      week_start = result.weekStart
      previous_week_start = week_start - 1.week

      break unless index + 1 < count

      loop do
        next_row = data[index + 1]
        row_week_start = Date.commercial(next_row['_id']['year'], next_row['_id']['week'], 1)
        break if row_week_start >= previous_week_start

        results << OpenStruct.new(
          id: previous_week_start.strftime('%Y-%W'),
          year: previous_week_start.year,
          week: previous_week_start.cweek,
          weekStart: previous_week_start,
          count: 0,
          duration: 0
        )

        previous_week_start -= 1.week
      end
    end
    results
  end
end

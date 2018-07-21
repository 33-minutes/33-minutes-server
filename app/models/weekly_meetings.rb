class WeeklyMeetings < SimpleDelegator
  def initialize(meetings)
    super meetings.collection.aggregate(
      [
        {
          '$group' => {
            _id: {
              year: { '$year' => '$started_at' },
              week: { '$week' => '$started_at' }
            },
            count: { '$sum' => 1 },
            duration: { '$sum' => { '$subtract' => ['$finished_at', '$started_at'] } }
          }
        }
      ]
    )
  end
end

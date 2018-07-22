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
end

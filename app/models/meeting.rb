class Meeting
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :started_at, type: DateTime
  field :finished_at, type: DateTime

  validates_presence_of :started_at
  validates_presence_of :finished_at
  validate :check_times

  belongs_to :user

  index({ user_id: 1, started_at: 1, finished_at: 1 }, unique: true)

  private

  def check_times
    return unless started_at && finished_at
    errors.add(:meeting, 'Meeting cannot finish before it started.') if started_at > finished_at
  end
end
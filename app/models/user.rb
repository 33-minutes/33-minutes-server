class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  field :email, type: String
  validates :email, email: true
  index({ email: 1 }, unique: true)

  field :weekly_meeting_budget, type: Float, default: 10

  attr_accessor :password
  validates :password, length: { within: 6..40 }, if: proc { |u| u.password }

  field :password_digest, type: String
  validates_presence_of :password_digest

  validates_presence_of :email, message: 'Email address is required.'
  validates_uniqueness_of :email, message: 'Email address already in use.'

  before_validation :encrypt_password

  def authenticate(password)
    return self if BCrypt::Password.new(password_digest) == password
  end

  has_many :meetings

  def weekly_meetings
    WeeklyMeetings.new(meetings)
  end

  protected

  def encrypt_password
    self.password_digest = BCrypt::Password.create(password) if password
  end
end

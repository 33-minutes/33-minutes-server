class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  field :email, type: String
  validates_presence_of :email
  index({ email: 1 }, unique: true)

  attr_accessor :password

  field :password_digest, type: String
  validates_presence_of :password_digest

  validates_presence_of :email, message: 'Email address is required.'
  validates_uniqueness_of :email, message: 'Email address already in use.'
  validates_format_of :email, with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i, message: 'Please enter a valid email address.'

  before_validation :encrypt_password

  def authenticate(password)
    return self if BCrypt::Password.new(password_digest) == password
  end

  protected

  def encrypt_password
    self.password_digest = BCrypt::Password.create(password) if password
  end
end

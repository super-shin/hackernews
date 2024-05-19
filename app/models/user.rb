require 'bcrypt'

class User < ActiveRecord::Base
  has_many :posts

  # TODO: Copy-paste your code from previous exercise
  before_validation :stripper
  before_validation :encrypt

  # TODO: Add some validation
  validates_presence_of :email, :username, :password_hash
  validates :username, uniqueness: true
  validates :email, format: { with: /.+@.+\.[a-z]{3}/ }
  def stripper
    self.email = email.strip unless email.nil?
  end

  def password
    self.password_hash ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password)
    self.password_hash = BCrypt::Password.create(new_password)
  end

  def encrypt
    self.password_hash = BCrypt::Password.create(self.password_hash)
  end
end

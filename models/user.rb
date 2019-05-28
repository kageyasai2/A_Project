require 'active_record'

class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :password, length: { minimum: 4, maximum: 32 }
  has_secure_password
  has_many :user_foods
  has_many :discarded_foods

  def self.exists_email_into_user_table(email)
    email = User.where(email: email).limit(1)
    if email.present?
      true
    else
      false
    end
  end

end

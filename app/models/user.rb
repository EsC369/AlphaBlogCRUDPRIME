class User < ActiveRecord::Base
    acts_as_voter
    # has_many :likes, dependent: :destroy
    has_many :articles
    # has_many :articles_liked, through: :likes, source: :articles
    has_secure_password
    #before_save { self.email = email.downcase } # changing all emails to lower case
    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
    NORM_REGEX = /\A[a-zA-Z0-9\s]+\z/i
    validates :username, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: { case_sensitive: false}, format: { with: NORM_REGEX, message: "Can Only Contain Letters And Numbers." }
    validates :email, presence: true, length: { minimum: 3, maximum: 100 }, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
end

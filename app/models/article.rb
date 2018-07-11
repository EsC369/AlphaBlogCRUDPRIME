class Article < ActiveRecord::Base
    acts_as_votable
    # has_many :likes
    belongs_to :user
    validates :title, presence: true, length: { minimum: 3, maximum: 50 }
    validates :description, presence: true, length: { minimum: 3, maximum: 300 }
    validates :user_id, presence: true
end
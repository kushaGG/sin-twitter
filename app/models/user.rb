class User < ActiveRecord::Base
	has_many :tweets, foreign_key: :user_id, dependent: :destroy

	has_many :messages

	has_many :relationships, foreign_key: :follower_id, class_name: "Relationship", dependent: :destroy
  has_many :followed, through: :relationships #, source: :followed

  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reverse_relationships #, source: :follower


  validates :user_name, format: { without: /\s/, message: "must contain no spaces" }
  validates :user_name, uniqueness: true
  validates :user_name, presence: true
	validates :email, uniqueness: true
	validates :email, presence: true
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, message: "Only valid email allowed."}
	validates :password, length: 6..20, on: :create

	has_secure_password

  def follow!(user)
    followed << user
  end


  # Returns true if the current user is following the other user.
  def following?(user)
    followed.include?(user)
  end

  def self.search(search)
    where('user_name LIKE :term', :term => "%#{search}%")
  end




end

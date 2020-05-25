class User < ApplicationRecord

  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 15 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8, maximum: 16 },
                       format: { with: /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]{8,16}+\z/ }, if: :update_password?
  validates :self_introduction, length: { maximum: 500 }
  validates :checkbox_user, presence: true

  has_many :favorites, dependent: :destroy
  has_many :already_fav, through: :favorites, source: :novel, dependent: :destroy
  has_many :novels, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow, dependent: :destroy
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def favorite(posted)
    self.favorites.find_or_create_by(novel_id: posted.id)
  end
  
  def unfavorite(posted)
    favorite = self.favorites.find_by(novel_id: posted.id)
    favorite.destroy if favorite
  end
  
  def already_fav?(posted)
    self.already_fav.include?(posted)
  end
  
  def list_fav
    Novel.where(id: self.already_fav_ids)
  end
  
  def update_password?
    password.to_s != ''
  end
  
end

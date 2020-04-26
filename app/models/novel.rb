class Novel < ApplicationRecord
  is_impressionable
  
  belongs_to :user
  
  has_many :favorites, dependent: :destroy
  has_many :fav_user, through: :favorites, source: :user, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true, length: { maximum: 50 }
  validates :outline, presence: true, length: { maximum: 1000 }
  validates :content, presence: true, length: { minimum: 50, maximum: 50000}
  validates :fin, presence: true
  
end

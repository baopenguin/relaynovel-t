class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :novel
  has_many :notifications, dependent: :destroy
  
  validates :content, presence: true, length: { maximum: 250 }
  
end

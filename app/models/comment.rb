class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :novel
  
  validates :content, presence: true, length: { maximum: 300 }
end

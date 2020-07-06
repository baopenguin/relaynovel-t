class Novel < ApplicationRecord
  is_impressionable
  
  belongs_to :user
  
  has_many :favorites, dependent: :destroy
  has_many :fav_user, through: :favorites, source: :user, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  
  has_many :notifications, dependent: :destroy
  
  validates :title, presence: true, length: { maximum: 50 }
  validates :outline, presence: true, length: { maximum: 1000 }
  validates :content, presence: true, length: { minimum: 50, maximum: 50000}
  validates :fin, presence: true
  
  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and novel_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        novel_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  
  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    # temp_ids = Comment.select(:user_id).where(novel_id: id).where.not(user_id: current_user.id).distinct
    # temp_ids.each do |temp_id|
    #   save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    # end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id)
    # if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      novel_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  
  def create_notification_story!(current_user)
    # すでに「続編作成」されているか検索
    temp_s = Notification.where(["visitor_id = ? and visited_id = ? and novel_id = ? and action = ? ", current_user.id, user_id, id, 'story'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp_s.blank?
      notification = current_user.active_notifications.new(
        novel_id: id,
        visited_id: user_id,
        action: 'story'
      )
      # 自分の投稿に対する続編作成の場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

end
module NotificationsHelper
  def notification_form(notification)
    @comment=nil
    visiter=link_to notification.visitor.name, notification.visitor, style:"font-weight: bold;"
    your_novel=link_to 'あなたの投稿', notification.novel, style:"font-weight: bold;"
    case notification.action
      when "follow" then
        "#{visiter}があなたをフォローしました"
      when "like" then
        "#{visiter}が#{your_novel}にいいね！しました"
      when "comment" then
        @comment=Comment.find_by(id:notification.comment_id)&.content
        "#{visiter}が#{your_novel}にコメントしました"
        
      when "story" then
        "#{visiter}が#{your_novel}の続編を投稿しました"
    end
  end
  
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
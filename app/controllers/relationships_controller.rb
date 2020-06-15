class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:follow_id])
    current_user.follow(user)
    
    user.create_notification_follow!(current_user)
    
    flash[:success] = 'ユーザをフォローしました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    user = User.find(params[:follow_id])
    current_user.unfollow(user)
    flash[:success] = 'ユーザのフォローを解除しました。'
    redirect_back(fallback_location: root_path)
  end
end

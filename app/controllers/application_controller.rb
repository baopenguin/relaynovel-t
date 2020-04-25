class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts_follow_unfollow(user)
    @count_novels = user.novels.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_favorites = user.already_fav.count
  end
  
  def still
    redirect_back(fallback_location: root_path)
  end
  
end

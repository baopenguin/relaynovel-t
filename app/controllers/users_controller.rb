class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :edit, :update, :destroy, :form]
  before_action :still, only:[:index]
  
  def index
  end

  def show
    @user = User.find(params[:id])
    @novels = @user.novels.order(id: :desc)
    @novels_s = @novels.where(parent_id: @novels)
    counts(@user)
    counts_follow_unfollow(@user)
  end
  
  def relaied
    @user = User.find(params[:id])
    @novels = @user.novels.order(id: :desc) 
    @novels_r = @novels.where.not(parent_id: @novels)
    @novel_all = Novel.all
    
    counts(@user)
    counts_follow_unfollow(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      log_in(@user)
      flash[:success] = 'アカウントを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'アカウントの登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
 
    if current_user == @user
      if @user.update(user_params)
        flash[:success] = 'プロフィールを編集しました。'
        redirect_to @user
      else
        flash.now[:danger] = 'プロフィールの編集に失敗しました。'
        render :edit
      end   
    else
        redirect_to root_url
    end
  end

  def destroy
    # @user = current_user
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'ユーザーを削除しました。'
    redirect_to root_url
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.order(id: :desc)
    counts_follow_unfollow(@user)
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.order(id: :desc)
    counts_follow_unfollow(@user)
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    # @novels = @user.list_fav.order(id: :asc).page(params[:page])
    @novels = @user.favorites.order(created_at: "DESC").map{|favorite| favorite.novel}
    counts_follow_unfollow(@user)
    counts(@user)
  end
  
  def form
  end
  
  helper_method :nextcount

  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :self_introduction, :twitter, :checkbox_user)
  end
  
  def counts(user)
    @user_novel_all = user.novels
    @s = []
    @r = []
    
    @user_novel_all.each do |user_novel|
      if user_novel.id == user_novel.parent_id
        @s.push(user_novel)
      else
        @r.push(user_novel)
      end
    end
    @count_novels_self = @s.count
    @count_novels_relay = @r.count
  end
  
  def nextcount(novel)
    @nextnovels = Novel.where(parent_id: novel.id).where('id != ? ', novel.id )
    @nextcount = @nextnovels.count
    
    return @nextcount
  end
  
end

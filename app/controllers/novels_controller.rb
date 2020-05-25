class NovelsController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :continue, :last, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update,:destroy]
  before_action :story_end_check, only: [:last]
  before_action :story_continue_check, only: [:continue]
  before_action :before_destroy, only:[:destroy]
  before_action :before_destroy_check, only:[:destroy]
  before_action :before_index, only:[:index]
  # 未実装
  before_action :still, only:[:edit, :update]  
  
  impressionist :actions=> [:show]


  
  def index
    @novels = Novel.all.order(id: "DESC")
  end
  
  def unfinished
    @novels = Novel.all.order(id: "DESC")
    @novels.each do |novel|
    end
  end
  
  def ranking
    @ranking = Novel.find(Favorite.group(:novel_id).order('count(novel_id) desc').pluck(:novel_id))
    @order = 0
  end
  
  def ranking_relay
    @ranking = Novel.find(Favorite.group(:novel_id).order('count(novel_id) desc').pluck(:novel_id))
    @order = 0
  end
  
  def following_novels
    @user  = current_user
    @users = @user.followings
    @novels = []
    if @users.present?
      @users.each do |user|
        user_novels = Novel.where(user_id: user.id).order(created_at: :desc)
        @novels.concat(user_novels)
      end
      @timeline = @novels.sort_by{|novel| novel.created_at}.reverse
        if @novels.nil?
          flash[:notice]="まだ投稿がありません…"
          redirect_to("/")
        end
    end
  end
  
  def following_relay
    @user  = current_user
    @users = @user.followings
    @novels = []
    if @users.present?
      @users.each do |user|
        user_novels = Novel.where(user_id: user.id).order(created_at: :desc)
        @novels.concat(user_novels)
      end
      @timeline = @novels.sort_by{|novel| novel.created_at}.reverse
        if @novels.nil?
          flash[:notice]="まだ投稿がありません…"
          redirect_to("/")
        end
    end
  end

  def show
    @novel = Novel.find(params[:id])
    @next_novels = Novel.where(parent_id: @novel.id).where('id > ?', @novel.id)
    if @novel.fin != 3
      @parent_novel = Novel.find_by(id: @novel.parent_id)
      @grandparent_novel = Novel.find_by(id: @novel.grandparent_id)
    end
    @url = request.url
    
    # @comments = @novel.comments
    @comment = Comment.new
    
    impressionist(@novel, nil)
    
  end

  def new
    @novel = Novel.new
  end
  
  def continue
    @novel = Novel.find(params[:id])
  end
  
  def last
    @novel = Novel.find(params[:id])
  end

  def create
    @novel = current_user.novels.build(novel_params)
    if @novel.save
      parent_info
      grandparent_info
      fin_info
      flash[:success] = 'ストーリーを投稿しました。'
      redirect_to user_path(current_user)
    else
      @novels = current_user.novels.order(id: :desc).page(params[:page])
      flash[:danger] = 'ストーリーの投稿に失敗しました。'
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @novel.destroy
    flash[:success] = 'ストーリーを削除しました。'
    redirect_to user_path(current_user)
  end
  
  def about
  end
  
  def qanda
  end
  
  def guideline
  end
  
  def rule
  end
  
  def privacy
  end
  
  
  helper_method :next_next
  helper_method :nextcount
  
  private
  
  def next_next(sequel)
    @a = Novel.find_by(id: sequel.id)
    @b = Novel.where(parent_id: @a.id)
    if @b.present?
      return 'さらにリレーが続けられています'
    else
      return '続きのストーリーは投稿されていません'
    end
  end
  
  def novel_params
    params.require(:novel).permit(:title, :outline, :content, :parent_id, :grandparent_id, :fin, :user_id)
  end
  
  def parent_info
    if @novel.parent_id == nil
      @novel.parent_id = @novel.id
      @novel.save
    end
  end
  
  def grandparent_info
    if @novel.grandparent_id == nil
      @novel.grandparent_id = @novel.id
      @novel.save
    end
  end
  
  def fin_info
    @grand_novel = Novel.find_by(id: @novel.grandparent_id)
    if @novel.fin == 1 && @grand_novel.fin == 0
      @grand_novel.fin = 1
      @grand_novel.save
    end
  end
  
  def correct_user
    @novel = current_user.novels.find_by(id: params[:id])
    unless @novel
      redirect_to login_path
    end
  end
  
  def story_continue_check
    @novel = Novel.find(params[:id])
    unless @novel.parent_id == @novel.grandparent_id
      redirect_to @novel
    end
  end
  
  def story_end_check
    @novel = Novel.find(params[:id])
    unless @novel.parent_id != @novel.grandparent_id
      redirect_to @novel
    end
  end
  
  def before_destroy
    @children = Novel.where(parent_id: @novel.id)
    @children.each do |child|
      child.fin = 3
      child.save
    end
  end
    
  def before_destroy_check
    @g = Novel.find_by(id: @novel.grandparent_id)
    @g.fin = 0
    @g.save
  end 
  
  def before_index
    @grands = Novel.where(fin: 0)
    @grands.each do |grand|
      if grand.id == grand.parent_id && grand.fin == 0
        @end = Novel.where(grandparent_id: grand.id).where(fin: 1)
        if @end
          @end.each do |ketsu|
            @third = Novel.where(id: ketsu.parent_id).where(fin: 0)
            if @third
              grand.fin = 1
              grand.save
            end
          end
        end
      end
    end
  end
  
  def nextcount(novel)
    @nextnovels = Novel.where(parent_id: novel.id).where('id != ? ', novel.id )
    @nextcount = @nextnovels.count
    
    return @nextcount
  end
  
end
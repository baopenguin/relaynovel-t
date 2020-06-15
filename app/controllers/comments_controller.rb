class CommentsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @novel = Novel.find(params[:novel_id])
    @comment = @novel.comments.build(comment_params)
    
    @comment.user_id = current_user.id
    @comment_novel = @comment.novel
    
    if @comment.save
      @comment_novel.create_notification_comment!(current_user, @comment.id)
      flash[:success] = 'レビューを投稿しました。'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = 'レビューの投稿に失敗しました。'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    # @novel = Novel.find(params[:id])
    # @comment = @novel.comments.find_by(params[:id])
    # @comment.destroy
    Comment.find_by(id: params[:id], novel_id: params[:novel_id]).destroy
    flash[:success] = 'レビューを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private
  
  def comment_params
    params.require(:comment).permit(:content)
  end
end

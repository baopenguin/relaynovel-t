class FavoritesController < ApplicationController
  def create
    novel = Novel.find(params[:novel_id])
    current_user.favorite(novel)
    flash[:success] = 'ストーリーをお気に入りに追加しました。'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    novel = Novel.find(params[:novel_id])
    current_user.unfavorite(novel)
    flash[:success] = 'ストーリーをお気に入りから削除しました。'
    redirect_back(fallback_location: root_path)
  end
end

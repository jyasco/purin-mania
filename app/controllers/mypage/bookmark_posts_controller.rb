class Mypage::BookmarkPostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @bookmarked_posts = Post.joins(:bookmarks)
                            .where(bookmarks: { user_id: current_user.id })
                            .includes(:user)
                            .order('bookmarks.created_at DESC')
                            .page(params[:page])
  end
end
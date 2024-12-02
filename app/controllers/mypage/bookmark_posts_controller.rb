class Mypage::BookmarkPostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @bookmarked_posts = current_user.bookmarks.includes(post: :user).order(created_at: :desc).map(&:post)
  end
end
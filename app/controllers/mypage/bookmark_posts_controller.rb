class Mypage::BookmarkPostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookmarked_posts = current_user.bookmark_posts.includes(:user).order(created_at: :desc)
  end
end
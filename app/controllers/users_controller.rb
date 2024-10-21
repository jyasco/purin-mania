class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
  end
end
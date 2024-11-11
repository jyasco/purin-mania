class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find_by(username: params[:username])
    
    if @user.nil?
      redirect_to root_path, alert: "ユーザーが見つかりませんでした。"
    elsif @user == current_user
      redirect_to mypage_mypage_path
    else
      @posts = @user.posts.includes(:user).order(created_at: :desc)
    end
  end
end
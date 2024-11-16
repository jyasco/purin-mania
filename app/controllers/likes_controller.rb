class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.like(@post)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @post = current_user.likes.find(params[:id]).post
    current_user.unlike(@post)
    respond_to do |format|
      format.turbo_stream
    end
  end
end
class MapsController < ApplicationController
  def index
    @posts = Post.includes(:user, :shop).where.not(shops: { address: "", latitude: nil, longitude: nil })
  end
end
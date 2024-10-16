class PostsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @posts = Post.includes(:user, :shop).order(created_at: :desc)
  end

  def new
    @post = Post.new
    @post.build_shop  # 新しい店舗を作成するための空のオブジェクトを用意
  end

  def create
    @post = current_user.posts.build(post_params.except(:shop_name, :shop_address))
    if @post.save
      # Shopの作成または更新
      shop = Shop.find_or_initialize_by(name: post_params[:shop_name])
      shop.update(address: post_params[:shop_address])
      @post.update(shop: shop)
  
      redirect_to @post, notice: '投稿が作成されました。'
    else
      flash.now[:danger] = "投稿に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:body, :sweetness, :firmness, :overall_rating, :shop_name, :shop_address)
  end
end
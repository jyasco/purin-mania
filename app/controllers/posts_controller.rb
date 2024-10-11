class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user, :shop).order(created_at: :desc)
  end

  def new
    @post = Post.new
    @post.build_shop  # 新しい店舗を作成するための空のオブジェクトを用意
  end

  def create
    @post = current_user.posts.build(post_params.except(:shop_name, :shop_address))
    Rails.logger.debug "Post params: #{post_params.inspect}"
    Rails.logger.debug "Post valid? #{@post.valid?}"
    Rails.logger.debug "Post errors: #{@post.errors.full_messages}" if @post.invalid?

    if @post.save
      # Shopの作成または更新
      shop = Shop.find_or_initialize_by(name: post_params[:shop_name])
      shop.update(address: post_params[:shop_address])
      @post.update(shop: shop)
  
      redirect_to @post, notice: '投稿が作成されました。'
    else
      render :new
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :sweetness, :firmness, :overall_rating, :shop_name, :shop_address)
  end
end
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
  
    # 既存の店舗を探すか、新しい店舗を作成
    shop = Shop.find_or_initialize_by(name: post_params[:shop_name])
    shop.address = post_params[:shop_address] if shop.new_record? || shop.address.blank?
  
    @post.shop = shop
  
    if @post.save
      shop.save
      redirect_to @post, notice: t('defaults.flash_message.created', item: Post.model_name.human)
    else
      flash.now[:alert] = t('defaults.flash_message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
    @post.shop_name = @post.shop&.name
    @post.shop_address = @post.shop&.address
  end

  def update
    @post = current_user.posts.find(params[:id])
    # 新しい画像がアップロードされた場合、古い画像を削除
    if post_params[:image].present? && @post.image.attached?
      @post.image.purge
    end
    
    @post.assign_attributes(post_params.except(:shop_name, :shop_address))
  
    # 既存の店舗を探すか、新しい店舗を作成
    shop = Shop.find_or_initialize_by(name: post_params[:shop_name])
    shop.address = post_params[:shop_address] if shop.new_record? || shop.address.blank?
  
    @post.shop = shop
  
    if @post.save
      shop.save
      redirect_to @post, notice: t('defaults.flash_message.updated', item: Post.model_name.human)
    else
      flash.now[:alert] = t('defaults.flash_message.not_updated', item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.image.purge if post.image.attached?
    post.destroy!
    redirect_to posts_path, notice: t('defaults.flash_message.deleted', item: Post.model_name.human), status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:body, :sweetness, :firmness, :overall_rating, :shop_name, :shop_address, :image)
  end
end
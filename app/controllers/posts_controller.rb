class PostsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
              .includes(:user, :shop)
              .with_attached_image
              .order(created_at: :desc)
  end

  def new
    @post = Post.new
    @post.build_shop  # 新しい店舗を作成するための空のオブジェクトを用意
  end

  def create
    @post = current_user.posts.build(post_params.except(:shop_name, :shop_address))
  
    shop = find_or_create_shop(post_params[:shop_name], post_params[:shop_address])
  
    @post.shop = shop
  
    if @post.save
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
    shop = find_or_create_shop(post_params[:shop_name], post_params[:shop_address])
  
    @post.shop = shop
  
    if @post.save
      redirect_to @post, notice: t('defaults.flash_message.updated', item: Post.model_name.human)
    else
      flash.now[:alert] = t('defaults.flash_message.not_updated', item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.image.purge if @post.image.attached?
    @post.destroy!
    
    flash[:notice] = t('defaults.flash_message.deleted', item: Post.model_name.human)
    
    respond_to do |format|
      format.html do
        if request.referer&.include?('mypage')
          redirect_to mypage_posts_path, status: :see_other
        else
          redirect_to posts_path, status: :see_other
        end
      end
      format.turbo_stream do
        if request.referer&.include?(post_path(@post))
          redirect_to posts_path, status: :see_other
        else
          render turbo_stream: [
            turbo_stream.remove(@post),
            turbo_stream.replace('flash', partial: 'shared/flash_messages')
          ]
        end
      end
    end
  end

  def liked_users
    @post = Post.find(params[:id])
    @liked_users = @post.liked_users.order(created_at: :desc)
  end

  private

  def find_or_create_shop(name, address)
    # 店名と住所が完全に一致する店舗を探す
    shop = Shop.find_by(name: name, address: address)
    return shop if shop
  
    # 店名のみが一致する店舗を探す
    existing_shops = Shop.where(name: name)
    
    if existing_shops.exists?
      # 店名が一致する店舗があるが、住所が異なる場合は新しい店舗を作成
      return Shop.create(name: name, address: address)
    end
  
    # 完全に新しい店舗の場合
    Shop.create(name: name, address: address)
  end

  def post_params
    params.require(:post).permit(:body, :sweetness_percentage, :firmness_percentage, :overall_rating, :shop_name, :shop_address, :image, :category)
  end
end
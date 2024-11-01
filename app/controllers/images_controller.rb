class ImagesController < ApplicationController
  def ogp
    post = Post.find(params[:id])
    text = post.shop.name
    has_image = post.image.attached?

    image = OgpCreator.build(text, has_image).tempfile.open.read
    send_data image, type: 'image/png', disposition: 'inline'
  end

  private

  def ogp_params
    params.permit(:id)
  end
end
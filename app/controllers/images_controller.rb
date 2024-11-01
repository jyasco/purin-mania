# app/controllers/images_controller.rb
class ImagesController < ApplicationController
  def ogp
    post = Post.find(params[:id])

    image = OgpCreator.build(post).tempfile.open.read
    send_data image, type: 'image/png', disposition: 'inline'
  end

  private

  def ogp_params
    params.permit(:id)
  end
end
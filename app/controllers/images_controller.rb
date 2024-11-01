class ImagesController < ApplicationController
  def ogp
    post = Post.find(params[:id])

    image = OgpCreator.build(post).tempfile.open.read
    send_data image, type: 'image/png', disposition: 'inline'
  end
end
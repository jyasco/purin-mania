class OgpCreator
  require 'mini_magick'  
  BASE_IMAGE_PATH = './app/assets/images/ogp.png'
  DEFAULT_OGP_PATH = './app/assets/images/default-ogp.png'
  FONT = './app/assets/fonts/KosugiMaru-Regular.ttf'
  BOLD_FONT = './app/assets/fonts/MPLUSRounded1c-Bold.ttf'
  TEXT_COLOR = '#2C1803'
  SHADOW_COLOR = 'rgba(20,10,0,0.6)'

  def self.build(post)
    if post.image.attached?
      image = MiniMagick::Image.open(BASE_IMAGE_PATH)
      image_width = image.width
      image_height = image.height
      post_image = MiniMagick::Image.read(post.image.download)
      post_image.resize "#{image_width / 2}x820^"
      post_image.gravity 'center'
      post_image.extent "#{image_width / 2}x820"
      y_offset = (image_height - 820) / 2
      image = image.composite(post_image) do |c|
        c.compose "Over"
        c.geometry "+#{image_width / 2}+#{y_offset}"
      end

      image.combine_options do |config|
        # 店舗名
        config.gravity 'West'
        config.font BOLD_FONT
        config.fill TEXT_COLOR
        config.pointsize 80
        config.draw "text 260,0 '#{post.shop.name}'"
        
        # ユーザー名
        config.gravity 'West'
        config.font FONT
        config.fill SHADOW_COLOR
        config.pointsize 32
        config.draw "text 450,140 'by #{post.user.name}'"
      end
    else
      image = MiniMagick::Image.open(DEFAULT_OGP_PATH)
    end

    image
  end
end
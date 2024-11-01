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
      left_half_width = image_width / 2

      post_image = MiniMagick::Image.read(post.image.download)
      post_image.resize "#{left_half_width}x745^"
      post_image.gravity 'center'
      post_image.extent "#{left_half_width}x745"
      y_offset = (image_height - 745) / 2
      image = image.composite(post_image) do |c|
        c.compose "Over"
        c.geometry "+#{left_half_width}+#{y_offset}"
      end

      # 店名を2段に分ける処理
      shop_name = post.shop.name
      if shop_name.length > 10
        mid_point = shop_name.length / 2
        split_point = shop_name[0...mid_point].rindex(/\s|　/) || mid_point
        first_line = shop_name[0...split_point].strip
        second_line = shop_name[split_point..-1].strip
      else
        first_line = shop_name
        second_line = nil
      end

      image.combine_options do |config|
        config.font BOLD_FONT
        config.fill TEXT_COLOR
        config.pointsize 60

        # 1段目のテキストを縦方向の中央に配置
        config.gravity 'Center'
        y_offset = second_line ? -35 : 0
        config.draw "text -#{left_half_width / 2},#{y_offset} '#{first_line}'"

        # 2段目のテキストがある場合は追加
        if second_line
          config.draw "text -#{left_half_width / 2},35 '#{second_line}'"
        end

        # ユーザー名を店舗名の下に配置
        config.font FONT
        config.fill SHADOW_COLOR
        config.pointsize 32
        y_offset = second_line ? 130 : 100
        config.draw "text -#{left_half_width / 2},+#{y_offset} 'by #{post.user.name}'"
      end
    else
      image = MiniMagick::Image.open(DEFAULT_OGP_PATH)
    end

    image
  end
end
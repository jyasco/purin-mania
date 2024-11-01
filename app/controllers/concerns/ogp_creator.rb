class OgpCreator
  require 'mini_magick'  
  BASE_IMAGE_PATH = './app/assets/images/ogp.png'
  DEFAULT_OGP_PATH = './app/assets/images/default-ogp.png'
  GRAVITY = 'center'
  TEXT_POSITION = '0,0'
  FONT = './app/assets/fonts/KosugiMaru-Regular.ttf'
  FONT_SIZE = 60
  INDENTION_COUNT = 16
  ROW_LIMIT = 2

  def self.build(text, post_has_image)
    if post_has_image
      text = prepare_text(text)
      image = MiniMagick::Image.open(BASE_IMAGE_PATH)
      image.combine_options do |config|
        config.font FONT
        config.fill 'white'
        config.gravity GRAVITY
        config.pointsize FONT_SIZE
        config.draw "text #{TEXT_POSITION} '#{text}'"
      end
      image
    else
      MiniMagick::Image.open(DEFAULT_OGP_PATH)
    end
  end

  private
  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end
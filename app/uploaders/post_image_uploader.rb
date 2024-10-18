class PostImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*args)
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end
  
  # アップロード時に WebP に変換
  process :convert_to_webp
  process resize_to_fill: [300, 300]

  # Process files as they are uploaded:
  # process scale: [200, 300]

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(jpg jpeg gif png webp)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # ファイル名を .webp に変更
  def filename
    "#{secure_token}.webp" if original_filename.present?
  end

  private

  def convert_to_webp
    manipulate! do |img|
      img.format 'webp'
      img.quality '80'  # 画質を80%に設定（調整可能）
      img
    end
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end

module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice
      'bg-[#4CAF50] text-white'
    when :alert, :error
      'bg-[#FF6B6B] text-white'
    else
      'bg-[#4CAF50] text-white'
    end
  end

  def sweetness_badge_color(sweetness)
    case sweetness
    when 'mild', 'prefer_mild'
      'bg-sweetLight text-textLight'
    when 'medium_sweet', 'prefer_medium_sweet'
      'bg-sweetMedium text-textLight'
    when 'sweet', 'prefer_sweet'
      'bg-sweetDeep text-textLight'
    else
      'bg-gray-400 text-textLight'
    end
  end

  def firmness_badge_color(firmness)
    case firmness
    when 'smooth', 'prefer_smooth'
      'bg-firmLight text-textLight'
    when 'medium_firm', 'prefer_medium_firm'
      'bg-firmMedium text-textLight'
    when 'firm', 'prefer_firm'
      'bg-firmDeep text-textLight'
    else
      'bg-gray-400 text-textLight'
    end
  end

  def show_meta_tags
    assign_meta_tags if display_meta_tags.blank?
    display_meta_tags
  end

  def page_title(title = '')
    base_title = 'PurinMania'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def assign_meta_tags(options = {})
    defaults = I18n.t('meta-tags.defaults', locale: :ja).deep_symbolize_keys
    options.reverse_merge!(defaults)

    title = content_for(:title).presence || options[:title]
    options[:title] = page_title(title)

    set_meta_tags(build_meta_tags(options))
  end

  private

  def build_meta_tags(options)
    {
      site: options[:site],
      title: options[:title],
      reverse: true,
      charset: 'utf-8',
      description: options[:description],
      keywords: options[:keywords],
      canonical: request.original_url,
      separator: '|',
      og: build_og_tags(options),
      twitter: build_twitter_tags(options)
    }
  end

  def build_og_tags(options)
    {
      site_name: options[:site],
      title: options[:title].presence || t('meta_tags.defaults.title'),
      description: options[:description],
      type: 'website',
      url: request.original_url,
      image: generate_ogp_image_url(options),
      locale: 'ja-JP'
    }
  end

  def build_twitter_tags(options)
    {
      card: 'summary_large_image',
      site: options[:site],
      image: generate_ogp_image_url(options)
    }
  end

  def generate_ogp_image_url(options)
    if options[:post].present? && options[:post].image.attached?
      Rails.application.routes.url_helpers.url_for(options[:post].image)
    else
      # デフォルトのOGP画像URL
      image_url('default-ogp.png')
    end
  end
end

module PostsHelper
  def sweetness_badge_color(sweetness)
    case sweetness
    when 'sweet'
      'bg-sweetDeep text-textLight'
    when 'medium_sweet'
      'bg-sweetMedium text-textLight'
    when 'mild'
      'bg-sweetLight text-textLight'
    else
      'bg-gray-400 text-textLight'
    end
  end
  
  def firmness_badge_color(firmness)
    case firmness
    when 'smooth'
      'bg-firmLight text-textLight'
    when 'medium_firm'
      'bg-firmMedium text-textLight'
    when 'firm'
      'bg-firmDeep text-textLight'
    else
      'bg-gray-400 text-textLight'
    end
  end
end
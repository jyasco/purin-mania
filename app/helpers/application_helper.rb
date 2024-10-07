module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice
      "bg-[#FFD681] text-[#2C1803]"
    when :alert
      "bg-[#9C661F] text-[#FFF5E6]"
    when :error
      "bg-[#C5B6A8] text-[#2C1803]"
    else
      "bg-[#FFF5E6] text-[#2C1803]"
    end
  end
end

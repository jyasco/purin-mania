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
end

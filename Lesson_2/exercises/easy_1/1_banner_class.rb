require 'pry'
system 'clear'

class Banner
  def initialize(message, banner_width=0)
    @message = message
    if banner_width.to_i == 0 || banner_width < message.size
      @banner_width = message.size
    else
      @banner_width = banner_width
    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private
  attr_reader :banner_width

  def horizontal_rule
    "+-#{"-" * line_spacing}-+"
  end

  def empty_line
    "| #{" " * line_spacing} |"
  end

  def message_line
    if @banner_width <= @message.size
      "| #{@message} |"
    else
      "| #{" " * padding}#{@message}#{" " * padding} |"
    end
  end

  def line_spacing
    if @banner_width.even?
      @banner_width
    else
      @banner_width + 1
    end
  end

  def padding
    if @banner_width.even?
      (@banner_width - @message.size) / 2
    else
      ((@banner_width - @message.size) / 2) + 1
    end
  end
end

banner = Banner.new('To boldly go where no one has gone before.', 50)
puts banner
puts
banner = Banner.new('', 26)
puts banner
banner = Banner.new('', 25)
puts banner

puts

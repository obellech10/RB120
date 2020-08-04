require 'pry'
system 'clear'

class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def switch_status
    switch
  end

  private
  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

test = Machine.new
test.start
puts test.switch_status
test.stop
puts test.switch_status

puts

require 'set'
system 'clear'

class MinilangError < StandardError; end
class BadTokenError < MinilangError; end
class EmptyStackError < MinilangError; end

class Minilang
  VALID_COMMANDS = %[PUSH ADD SUB MULT DIV MOD POP PRINT]

  def initialize(program)
    @register = 0
    @stack = []
    @program = program
  end

  def eval
    @program.split.each do |command|
      eval_command(command)
    end

  rescue MinilangError => error
    puts error.message
  end

  def eval_command(command)
    if VALID_COMMANDS.include?(command)
      send(command.downcase)
    elsif command =~ /\A[-+]?\d+\z/
      @register = command.to_i
    else
      raise BadTokenError, "Invalid Command: #{command}"
    end
  end

  def push
    @stack << @register
  end

  def add
    @register += @stack.pop
  end

  def sub
    @register -= @stack.pop
  end

  def mult
    @register *= @stack.pop
  end

  def div
    @register /= @stack.pop
  end

  def mod
    @register %= @stack.pop
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def print
    puts @register
  end

end

Minilang.new('PRINT').eval
# 0
puts

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15
puts

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8
puts

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5
puts

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!
puts

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6
puts

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12
puts

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB
puts

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8
puts

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

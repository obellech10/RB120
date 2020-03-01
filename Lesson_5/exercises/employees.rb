require 'pry'
system 'clear'

class Employee
  attr_reader :name, :serial_number, :type, :vacation, :desk

  def initialize(name, serial_number)
    @name = name
    @serial_number = serial_number
  end

  def to_s
    "Name: #{name}\n" +
    "Type: #{type}\n" +
    "Serial Number: #{serial_number}\n" +
    "Vacation: #{vacation}\n" +
    "Desk: #{desk}\n"
  end
end

class FullTimeEmployee < Employee
  def take_vacation
    puts "I'm on vacation"
  end
end

class PartTimeEmployee < Employee
  def initialize(name, serial_number)
    super
    @type = 'Part-Time'
    @vacation = 0
    @desk = 'Open Workspace'
  end
end

class Executive < FullTimeEmployee
  def initialize(name, serial_number)
    super
    @type = 'Executive'
    @vacation = 20
    @desk = 'Corner Office'
  end

  def delegate
    puts "I'm delgating"
  end
end

class Manager < Executive
  def initialize(name, serial_number)
    super
    @type = 'Manager'
    @vacation = 14
    @desk = 'Private Office'
  end
end

class RegularEmployee < FullTimeEmployee
  def initialize(name, serial_number)
    super
    @type = 'Regular'
    @vacation = 10
    @desk = 'Cubicle Farm'
  end
end

puts larry = Executive.new('Larry', 123456789)
larry.delegate
larry.take_vacation
puts
puts bob = Manager.new('Bob', 123456789)
bob.delegate
bob.take_vacation
puts
puts joe = RegularEmployee.new('Joe', 123456789)
# joe.delegate
joe.take_vacation
puts
puts pam = PartTimeEmployee.new('Pam', 123456789)
# pam.delegate
# pam.take_vacation

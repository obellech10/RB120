require 'pry'
system 'clear'

module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model

  @@number_of_vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(number)
    @current_speed += number
  end

  def brake(number)
    @current_speed -= number
  end

  def shut_off
    @current_speed = 0
  end

  def spray_paint(color)
    self.color = color
  end

  def self.gas_mileage(gallons, miles)
    gallons / miles
  end

  def self.number_of_vehicles
    puts @@number_of_vehicles
  end

  def age
    "Your #{self.model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - self.year
  end
end

class MyCar < Vehicle
  DRIVETRAIN = '2wd'

  def to_s
    "My car is a #{color}, #{year} #{model}"
  end
end

class MyTruck < Vehicle
  include Towable

  DRIVETRAIN = '4wd'

  def to_s
    "My car is a #{color}, #{year} #{model}"
  end
end

ewok = MyCar.new(1987, 'silver', 'Accord')
puts ewok
puts ewok.age
puts
rufus = MyTruck.new(2018, 'black', 'Tacoma')
Vehicle.number_of_vehicles
puts

puts "MyCar Method Lookup"
puts MyCar.ancestors
puts
puts "MyTruck Method Lookup"
puts MyTruck.ancestors
puts
puts "Vehicle Method Lookup"
puts Vehicle.ancestors

# class Student
#   def initialize(name, grade)
#     @name = name
#     @grade = grade
#   end
#
#   def better_grade_than?(student)
#     grade > student.grade
#   end
#
#   protected
#   attr_reader :grade
# end
#
# bob = Student.new('Bob', 84)
# joe = Student.new('Joe', 90)
#
# puts "Well done!" if joe.better_grade_than?(bob)

class Person
  attr_writer :first_name, :last_name

  def full_name
    # binding.pry
    "#{@first_name} #{@last_name}"
  end
end

mike = Person.new
mike.first_name = 'Michael'
mike.last_name = 'Garcia'
p mike.full_name # => 'Michael Garcia'

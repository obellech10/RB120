require 'pry'
system 'clear'

def problem(message)
  puts
  puts "**#{message}**"
end

problem("Banner Class")

class Banner
  def initialize(message, banner_width=0)
    @message = message
    if banner_width.to_i == 0
      @banner_width = message.size
    else
      @banner_width = banner_width
    end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

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

  attr_reader :banner_width
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
puts
banner = Banner.new('', 26)
puts banner
banner = Banner.new('', 25)
puts banner

problem("What's the output")

# class Pet
#   attr_reader :name
#
#   def initialize(name)
#     @name = name.to_s
#   end
#
#   def to_s
#     "My name is #{@name.upcase}."
#   end
# end
#
# name = 42
# fluffy = Pet.new(name)
# name += 1
# puts fluffy.name
# puts fluffy
# puts fluffy.name
# puts name

problem("Fix the Program - Books (Part 1)")

# class Book
#   attr_reader :author, :title
#
#   def initialize(author, title)
#     @author = author
#     @title = title
#   end
#
#   def to_s
#     %("#{title}", by #{author})
#   end
# end
#
# book = Book.new("Neil Stephenson", "Snow Crash")
# puts %(The author of "#{book.title}" is #{book.author}.)
# puts %(book = #{book}.)

problem("Fix the Program - Books (Part 2)")

class Book
  attr_accessor :title, :author

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

problem("Fix the Program - Persons")

class Person
  def initialize(first_name, last_name)
    @first_name = first_name.capitalize
    @last_name = last_name.capitalize
  end

  def to_s
    "#{@first_name} #{@last_name}"
  end

  def first_name=(first_name)
    @first_name = first_name.capitalize
  end

  def last_name=(last_name)
    @last_name = last_name.capitalize
  end
end

person = Person.new('john', 'doe')
puts person

person.first_name = 'jane'
person.last_name = 'smith'
puts person

problem("Buggy Code - Car Mileage")

# class Car
#   attr_accessor :mileage
#
#   def initialize
#     @mileage = 0
#   end
#
#   def increment_mileage(miles)
#     @mileage += miles
#   end
#
#   def print_mileage
#     puts mileage
#   end
# end
#
# car = Car.new
# car.mileage = 5000
# car.increment_mileage(678)
# car.print_mileage  # should print 5678
#
# problem("Rectangles and Squares")

class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end

  def area
    @height * @width
  end
end

class Square < Rectangle
  def initialize(length)
    super(length, length)
  end
end

square = Square.new(5)
puts "area of square = #{square.area}"

problem("Complete the Program - Cats!")

class Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  def initialize(name, age, color)
    super(name, age)
    @color = color
  end

  def to_s
    "My cat #{@name} is #{@age} years old and has #{@color} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch

problem("Refactoring Vehicles")

class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car < Vehicle
  def wheels
    4
  end
end

class Motorcycle < Vehicle
  def wheels
    2
  end
end

class Truck < Vehicle
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end

ewok = Car.new("Honda", "Accord")
puts ewok.make
puts ewok.model
whatev = Motorcycle.new("Yamaha", "400cc")
puts whatev.make
puts whatev.model
danny = Truck.new("Toyota", "Tacoma", "500lbs")
puts danny.make
puts danny.model
puts danny.payload

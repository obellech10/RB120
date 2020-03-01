require 'pry'
system 'clear'

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

puts

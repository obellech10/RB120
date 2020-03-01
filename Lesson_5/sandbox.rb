require 'pry'
system 'clear'


class Person
  @@total_people = 0
  attr_accessor :name, :weight, :height

  def initialize(name, weight, height)
    @name = name
    @weight = weight
    @height = height
    @@total_people += 1
  end

  def self.total_people
    @@total_people
  end

  def change_info(name, weight, height)
    self.name = name
    self.weight = weight
    self.height = height
  end
end

bob = Person.new('bob', 185, 70)
puts Person.total_people       # this should return 1
bob.change_info('Oscar', 200, 70)
p bob

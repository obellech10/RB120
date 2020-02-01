require 'pry'
system 'clear'


class Person
  attr_accessor :name, :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end

  def name=(name)
    parse_full_name(name)
  end

  def to_s
    name
  end

  private

  def parse_full_name(name)
    first_last = name.split
    @first_name = first_last.first
    @last_name = first_last.size > 1 ? first_last.last : ''
  end
end


bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name
puts "The person's name is: #{bob}"

require 'pry'
system 'clear'

class Flight
  # Remove the attr_accessor line. It's unneeded and unwanted and can cause issues
  # in the future if we change from using a database and if it's being used in other
  # programs and applications will cause that code to break and require modifications
  # of dependent code 

  # attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

puts

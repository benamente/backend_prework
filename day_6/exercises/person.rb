# Create a person class with at least 2 attributes and 2 behaviors.  Call all
# person methods below the class so that they print their result to the
# terminal.

class Person
  attr_accessor :name, :profession, :marital_status

  def initialize(name, profession)
    @name = name
    @profession = profession
    @marital_status = "married"
  end

  def cheat
    @marital_status = "divorced"
  end

  def change_profession(profession)
    @profession = profession
  end

  def info
    puts "Name: #{name}, \tProfession: #{profession}, \tMarital Status: #{marital_status}"
  end

end

indy = Person.new("Indiana Jones", "Professor")
indy.info
indy.change_profession("Adventurer")
indy.info
indy.cheat
indy.info

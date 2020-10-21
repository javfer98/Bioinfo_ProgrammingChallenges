class Human   

  attr_accessor :name  
  attr_accessor :age
  
  def initialize (params = {}) # get a name from the "new" call, or set a default
    #thisname = "Some Person", thisage = "0", thisid = "00000000", hasdiseases = []
    @name = params.fetch(:name, 'Some Person')
    @age = params.fetch(:age, "0")
  end
  
  #Task 4: People have birthdays!

  #Create a new method "birthday" that increments a person's age by 1 year prove that it works by incrementing the age of one of your patients and
  #printing it in a sentence like "my age is now 44 years old". Where should the birthday method be?
  
  
  def birthday
    @age = Integer(@age)
    @age += 1
    puts "my age is now #{@age}"
    
  end
  
end



#task 4 testing:

#alguien = (Human.new :name => "Mark Wilkinson", :age => "48")

#alguien.birthday

#puts alguien.age
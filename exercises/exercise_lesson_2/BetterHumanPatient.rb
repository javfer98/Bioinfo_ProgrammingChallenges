require './Human.rb'
require './Disease.rb'

class BetterHumanPatient < Human   
  
  attr_accessor :healthID

  # there are two methods with the same name, but different "signatures"
  # the first has no arguments, and it simply returns the current value of @diseases
  def diseases
    return @diseases
  end
  
  # the second has an argument - it is called when you say diseases = [X,Y]

  def diseases=(newvalue) # the newvalue is a list of diseases
    
    
 # Task 2: modify the BetterHumanPatient Class "diseases" method

  #The code currently assumes that it receives an array as an argument
  #(i.e. it calls the ".each" method on the incoming value, without checking if it really is an array! That's bad...).
  #Fix the diseases method of BetterHumanPatient so that it checks that newvalue is really an array,before it calls '.each'.
  #Think of a solution to this problem, rather than outputting an error...
    

  #  puts newvalue.class  #te dice el tipo de dato que hay en newvalue
    unless newvalue.class == Array #if newvalue is not an array
      list = Array.new
      list << newvalue #introduce newvalue in newlist
      newvalue = list #now newvalue is the list
    end
      
    #Task 3: "Duck Typing" in Ruby

    #We learned the "is_a?" method, and used it to test the newvalues are type "Disease". However, it is more common in Ruby to use "Duck Typing".
    #That means, instead of asking what Class an Object is, ask if it can respond to the method calls/properties you want to use on it. e.g.
    #in this case we want to use the ".name" and ".mesh" calls.
   
       
    for disease in newvalue.each    # this is a for-loop in Ruby
        newlist = Array.new  # create an array to hold the new list of diseases
      if disease.respond_to?('mesh') & disease.respond_to?('name')     # use the respond_to? para saber si el objeto que metemos tiene "mesh" y "name"
                                    # the call respond_to?  is better
        newlist << disease          #   this is how you add things to an array in Ruby
      else
        puts "note that #{disease} is not a Disease object - ignoring..."
      end
    end
    @diseases = newlist   # now set the value of @diseases to the new list of validated Disease objects
  end
  
  
  def initialize (params = {}) # get a name from the "new" call, or set a default
        
    # first, initialize the parent object
    super(params)  # super means "parent.new(params)"

    #thisname = "Some Person", thisage = "0", thisid = "00000000", hasdiseases = []
    @healthID = params.fetch(:healthID, "0000000")
  end

  # lets create a METHOD to check if the patient has a disease
  def has_disease (somedisease)
    if diseases.include?(somedisease)   # the "include?" method for lists (returns true or false)
      return "Patient Has #{somedisease} disease"   # the use of #{xx} to capture the variable value in a string
    else
      return "Patient does not have #{somedisease} disease"
    end
  end
  
end





# Tasks 2 and 3 testing:

#diabetes = Disease.new(:name => "Diabetes", :mesh => "C19.246")
#thyroiditis = Disease.new(:name => "Thyroiditis", :mesh => "C19.874.871")


#p2 = BetterHumanPatient.new(    #calls initialize
#  :name => "Mark Wilkinson",      # inherited from Human
#  :age => "48",                   # inherited from Human
#  :healthID => "163483", 
#  )
#puts "First Attempt - using strings..."
#p2.diseases=["Diabetes", "Thyroiditis"]  #calls diseases=(newvalue)
#puts;puts;
#puts "Second Attempt - using Disease objects"  #calls diseases=(newvalue)
#p2.diseases=[diabetes, thyroiditis]


#puts "test 1. Single string"  #calls diseases=(newvalue)
#p2.diseases="diabetes"
#puts p2.diseases[0].name


#puts "test 2. Single object"  #calls diseases=(newvalue)
#p2.diseases= diabetes
#puts p2.diseases[0].name



#Task 4 testing:

#p2.birthday

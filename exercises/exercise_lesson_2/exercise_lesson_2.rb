
class Disease  
  
  attr_accessor :name  
  
  #Task 1
  
  #We want to check that the MeSH code sent to the Disease object is really a MeSH code. ([A-Z](\d\d(.\d\d\d){0,5})?)
  
  #en lugar de usar attr_accessor :mesh hay que hacerlo manualmente.
  def mesh 
    return self.instance_variable_get(:@mesh)
  end

  def mesh=(value)
    
    match_mesh = Regex.new(/[A-Z](\d\d(.\d\d\d){0,5})?/)   
    
    if match_mesh.match(value)
      puts "match found!"
      return self.instance_variable_set(:@mesh, value)
    else puts "wrong MeSH code"
    end 
  end
    

  
  def initialize (params = {})
    @name = params.fetch(:name, 'unknown disease')
    @mesh = params.fetch(:mesh, "0000000")
  end
  
end



class Human   

  attr_accessor :name  
  attr_accessor :age
  
  def initialize (params = {}) # get a name from the "new" call, or set a default
    #thisname = "Some Person", thisage = "0", thisid = "00000000", hasdiseases = []
    @name = params.fetch(:name, 'Some Person')
    @age = params.fetch(:age, "0")
  end
  
end





class BetterHumanPatient < Human   
  
  attr_accessor :healthID

  # there are two methods with the same name, but different "signatures"
  # the first has no arguments, and it simply returns the current value of @diseases
  def diseases
    return @diseases
  end
  
  # the second has an argument - it is called when you say diseases = [X,Y]
  def diseases=(newvalue) # the newvalue is a list of diseases
    
    newlist = Array.new  # create an array to hold the new list of diseases
    for disease in newvalue.each    # this is a for-loop in Ruby
      if disease.is_a?(Disease)     # use the "is_a?" method to check the type of object
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

diabetes = Disease.new(:name => "Diabetes", :mesh => "C19.246")
thyroiditis = Disease.new(:name => "Thyroiditis", :mesh => "C19.874.871")

p2 = BetterHumanPatient.new(
  :name => "Mark Wilkinson",      # inherited from Human
  :age => "48",                   # inherited from Human
  :healthID => "163483", 
  )
puts "First Attempt - using strings..."
p2.diseases=["Diabetes", "Thyroiditis"]
puts;puts;
puts "Second Attempt - using Disease objects"
p2.diseases=[diabetes, thyroiditis]

for disease in p2.diseases.each
  puts "this patient has #{disease.name} with MeSH Code #{disease.mesh}"
end


class Disease  

 
  
  attr_accessor :name  
  
  #Task 1
  
  #We want to check that the MeSH code sent to the Disease object is really a MeSH code. ([A-Z](\d\d(.\d\d\d){0,5})?)
  
  
  #en lugar de usar attr_accessor :mesh hay que hacerlo manualmente. Así, cuando se use disease.mesh = mesh code se comprueba si el mesh code está bien
  def mesh #si pones solo mesh te devuelve el valor de mesh
    return self.instance_variable_get(:@mesh)
  end


  def mesh=(value) #si pones disease.mesh = mesh code se cambia el valor del mesh code por el introducido
    
    match_mesh = Regexp.new(/[A-Z]\d\d((.\d\d\d){0,5})?/)   #expresión regular para el mesh code.  
    
    if match_mesh.match(value) #si el valor introducido tiene forma de mesh code
      return self.instance_variable_set(:@mesh, value) #se cambia el valor a value
    else puts "wrong MeSH code. Ignoring" #si no se informa y no se cambia el valor.
    end 
  end
    

  
  def initialize (params = {})
    
    match_mesh = Regexp.new(/[A-Z]\d\d((.\d\d\d){0,5})?/)   #expresión regular para el mesh code.  
    
    @name = params.fetch(:name, 'unknown disease')
    @mesh = params.fetch(:mesh, "0000000")
    
    #Task 1
  
    #We want to check that the MeSH code sent to the Disease object is really a MeSH code. ([A-Z](\d\d(.\d\d\d){0,5})?)
    
    unless match_mesh.match(@mesh) #si el mesh code está mal
      puts "wrong MeSH code. Setting MeSH code to A00" #se informa de que está mal
      @mesh = "A00" #se cambia a A00
    end
  end
  
end


#Task 1 testing:

#diabetes = Disease.new(:name => "Diabetes", :mesh => "C19.246")
#try   diabetes = Disease.new(:name => "Diabetes", :mesh => "fgdfgd")
#diabetes.mesh = "A23.543"
#diabetes.mesh = "faklsfj"

#puts diabetes.name
#puts diabetes.mesh

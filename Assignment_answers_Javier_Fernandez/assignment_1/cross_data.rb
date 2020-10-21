class Cross_data   

  attr_accessor :parent1  
  attr_accessor :parent2
  attr_accessor :f2_wild 
  attr_accessor :f2_p1
  attr_accessor :f2_p2
  attr_accessor :f2_p1p2



  def initialize (params = {}) # get a name from the "new" call, or set a default
    @parent1 = params.fetch(:parent1, 'Unknown')
    @parent2 = params.fetch(:parent2, 'Unknown')
    @f2_wild = params.fetch(:f2_wild, '0')
    @f2_p1 = params.fetch(:f2_p1, '0')
    @f2_p2 = params.fetch(:f2_p2, '0')
    @f2_p1p2 = params.fetch(:f2_p1p2, '0')
  end
  
  

end




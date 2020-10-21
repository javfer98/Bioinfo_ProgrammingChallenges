class Gene_information  

  attr_accessor :gene_id  
  attr_accessor :gene_name
  attr_accessor :mutant_phenotype 




  def initialize (params = {}) # get a name from the "new" call, or set a default
    @gene_id = params.fetch(:gene_id, 'Default')
    @gene_name = params.fetch(:gene_name, 'Default')
    @mutant_phenotype = params.fetch(:mutant_phenotype, 'Default')

  end
  
  

end


require './seed_stock_data.rb'

class Merged_gene_seed_stock < Seed_stock_data   #inherit from Seed_stock_data
  
  attr_accessor :mutant_gene_name
  attr_accessor :mutant_phenotype
  attr_accessor :linked_to 

  def initialize (params = {}) # get a name from the "new" call, or set a default
        
    # initialize the parent object
    super(params)  # super means "parent.new(params)"
    @mutant_gene_name = params.fetch(:mutant_gene_name, "")
    @mutant_phenotype = params.fetch(:mutant_phenotype, "")
    @linked_to = params.fetch(:linked_to, nil)
  end
  
  def add_gene_information (gene_information_array) #adds gene_information contained in an array of instances.
    
    unless gene_information_array.class == Array #check that the input is an array
      puts "An array of instances of the class Gene_information is needed"
    else
      
      for instance in gene_information_array #check that the elements of the array are objects of the Gene_information class or similar
        
        unless instance.respond_to?('gene_id') & instance.respond_to?('gene_name') & instance.respond_to?('mutant_phenotype')
            puts "The elements of the array must be instances of the class Gene_information"
        else
          
          if self.mutant_gene_id == instance.gene_id #if the gene id is the same in the current object and in the input
            self.mutant_gene_name = instance.gene_name #take gene_name from the input and add it to the current object
            self.mutant_phenotype = instance.mutant_phenotype #take mutant_phenotype from the input and add it to the current object
          end
        end
        
      end
      
    end
    
  end

end



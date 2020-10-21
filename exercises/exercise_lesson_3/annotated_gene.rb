require './gene_information.rb'

class Annotated_gene < Gene_information 
 
  attr_accessor :dna_sequence
  attr_accessor :protein_sequence
  attr_accessor :uniprot_id


  def initialize (params = {}) # get a name from the "new" call, or set a default
        
    # first, initialize the parent object
    super(params)  # super means "parent.new(params)"

    #thisname = "Some Person", thisage = "0", thisid = "00000000", hasdiseases = []
    @dna_sequence = params.fetch(:dna_sequence, "")
    @protein_sequence = params.fetch(:protein_sequence, "")
    @uniprot_id = params.fetch(:uniprot_id, "") 
  end
 
  

end


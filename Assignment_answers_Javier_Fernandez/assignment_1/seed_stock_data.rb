class Seed_stock_data   

  attr_accessor :seed_stock  
  attr_accessor :mutant_gene_id
  attr_accessor :last_planted  
  attr_accessor :storage
  attr_accessor :grams_remaining



  def initialize (params = {}) # get a name from the "new" call, or set a default
    @seed_stock = params.fetch(:seed_stock, 'Default')
    @mutant_gene_id = params.fetch(:mutant_gene_id, 'Default')
    @last_planted = params.fetch(:last_planted, '0/0/0000')
    @storage = params.fetch(:storage, 'Default')
    @grams_remaining = params.fetch(:grams_remaining, '0')
  end
  
  

end




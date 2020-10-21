require './seed_stock_data.rb'
require './cross_data.rb'
require './gene_information.rb'


def read_tsv(path, class_to_fill, properties) #properties should be an array
  
  require "csv" #csv is used to read the tsv file.

  parsed_file = CSV.read(path, { :col_sep => "\t" }) #read the file and generate an array whose elements are the lines (also arrays)
  
  parsed_file.shift #remove first element (the headers)
  
  i = 0
  instances = Array.new()
  for line in parsed_file
      joined = line.zip properties #join line and properties array to be able to iterate through both of them at the same time
      instances[i] = class_to_fill.new()
      
      
        for element, property in joined
         # puts property
          #puts i
          instances[i].instance_variable_set(property, element)
          #puts instances[i-1].inspect
        end

    i += 1    
  end
  return instances
end




properties_array = [:@seed_stock, :@mutant_gene_id, :@last_planted, :@storage, :@grams_remaining]
  
seed_stock_instances = read_tsv("./seed_stock_data.tsv", Seed_stock_data, properties_array)




properties_array = [:@parent1, :@parent2, :@f2_wild, :@f2_p1, :@f2_p2, :@f2_p1p2]
  
cross_data_instances = read_tsv("./cross_data.tsv", Cross_data, properties_array)




properties_array = [:@gene_id, :@gene_name, :@mutant_phenotype]
  
gene_information_instances = read_tsv("./gene_information.tsv", Gene_information, properties_array)


#gene_information_instances.append(  #add new element with wrong gene ID format to check if I can reject incorrect formats.
#  Gene_information.new(
#  :gene_id => "dfgh",      
#  :gene_name => "afdghh",                  
#  :mutant_phenotype => "sdfaasdg",
#  ) 
#)

#puts gene_information_instances.inspect


#reject incorrect gene_id formats

for instance in gene_information_instances 
    match_gene_id = Regexp.new(/A[Tt]\d[Gg]\d\d\d\d\d/)
    unless  match_gene_id.match(instance.gene_id)
        instance.gene_id = 'check_format'
        puts 'WARNING: wrong gene ID format. ID format set to "check_format"'
    end    
end



#plant 7 grams of each seed and check if we have run out of any stock.

for instance in seed_stock_instances
    if instance.grams_remaining.to_f <= 7
      instance.grams_remaining = 0
      puts "WARNING: we have run out of Seed Stock #{instance.seed_stock}"
    else instance.grams_remaining =  (instance.grams_remaining.to_f - 7)
    end
end



#Print new Seed_Stock_Data to a file

File.write('./seed_stock_data_updated.tsv', '') #empty the file


#Add the header
File.write('./seed_stock_data_updated.tsv', "Seed_Stock\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Mutant_Gene_ID\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Last_Planted\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Storage\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Grams_Remaining\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "\n", mode: 'a')


#Add the content
for instance in seed_stock_instances
    File.write('./seed_stock_data_updated.tsv', "#{instance.seed_stock}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.mutant_gene_id}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.last_planted}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.storage}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.grams_remaining}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "\n", mode: 'a')
end



#test = Seed_stock_data.new(
#  :seed_stock => "dfgh",      # inherited from Human
#  :mutant_gene_id => "at45376ihj",                   # inherited from Human
#  :last_planted => "1/11/1111",
#  :storage => "cama",
#  :grams_remaining => "3",
#  )

#puts test.seed_stock





require './merged_gene_seed_stock.rb'
require './cross_data.rb'
require './gene_information.rb'


def read_tsv(path, class_to_fill, properties) #properties should be an array
  
  require "csv" #csv package is used to read the tsv file.

  parsed_file = CSV.read(path, { :col_sep => "\t" }) #read the file and generate an array whose elements are the lines (also arrays)
  
  parsed_file.shift #remove first element (the headers)
  
  unless properties.class == Array #check that the input is an array
    puts "The class properties must be in an array"
  else
    i = 0
    instances = Array.new()
    for line in parsed_file #iterate over the whole file
        joined = line.zip properties #join line and properties array to be able to iterate through both of them at the same time
        instances[i] = class_to_fill.new() #create a new instance and save it in the array "instances"

          for element, property in joined #iterate over the file line and the array of properties simultaneusly
            instances[i].instance_variable_set(property, element) #set the data taken from the file as the values of the properties
          end
  
      i += 1    
    end
    return instances
  end
end



#fill all the objects using the corresponding files as input. For each class all its objects are saved in an array


properties_array = [:@seed_stock, :@mutant_gene_id, :@last_planted, :@storage, :@grams_remaining]
  
merged_gene_seed_stock_instances = read_tsv("./seed_stock_data.tsv", Merged_gene_seed_stock, properties_array)




properties_array = [:@parent1, :@parent2, :@f2_wild, :@f2_p1, :@f2_p2, :@f2_p1p2]
  
cross_data_instances = read_tsv("./cross_data.tsv", Cross_data, properties_array)




properties_array = [:@gene_id, :@gene_name, :@mutant_phenotype]
  
gene_information_instances = read_tsv("./gene_information.tsv", Gene_information, properties_array)


#The Merged_gene_seed_stock class only has the seed stock data. We have to add the gene_information

merged_gene_seed_stock_instances[0].add_gene_information(gene_information_instances)  



#reject incorrect gene_id formats

for instance in merged_gene_seed_stock_instances  
    match_gene_id = Regexp.new(/A[Tt]\d[Gg]\d\d\d\d\d/) #define regular expression that defines gene_id_format
    unless  match_gene_id.match(instance.mutant_gene_id) #it the format is not what it should be
        instance.mutant_gene_id = 'check_format' #change mutant_gene_id to "check_format"
        puts 'WARNING: wrong gene ID format. ID format set to "check_format"' #print a warning
    end    
end



#plant 7 grams of each seed and check if we have run out of any stock.

for instance in merged_gene_seed_stock_instances
    if instance.grams_remaining.to_f <= 7 #if there are 7 or less grams in stock
      instance.grams_remaining = 0 #set grams_remaining to 0 to avoid negative values.
      puts "WARNING: we have run out of Seed Stock #{instance.seed_stock}" #print warning
    else instance.grams_remaining =  (instance.grams_remaining.to_f - 7) #if there are more than 7 grams in stock substract 7.
    end
end



#Print new Seed_Stock_Data to a file

File.write('./seed_stock_data_updated.tsv', '') #if the file seed_stock_data_updated.tsv already existed, it becomes empty


#Add the header. Note the mode: 'a'. It adds new content without overwriting.
File.write('./seed_stock_data_updated.tsv', "Seed_Stock\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Mutant_Gene_ID\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Last_Planted\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Storage\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "Grams_Remaining\t", mode: 'a')
File.write('./seed_stock_data_updated.tsv', "\n", mode: 'a')


#Add the content
for instance in merged_gene_seed_stock_instances #for every object in the class print the desired content. Each iteration adds a new row.
    File.write('./seed_stock_data_updated.tsv', "#{instance.seed_stock}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.mutant_gene_id}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.last_planted}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.storage}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "#{instance.grams_remaining}\t", mode: 'a')
    File.write('./seed_stock_data_updated.tsv', "\n", mode: 'a')
end



require "statistics2" #statistics2 package has chi square already implemented

for instance in cross_data_instances #iterate over the Cross_data class
  total_number = 0
  chi_square = 0
  
  observed = [instance.f2_wild, instance.f2_p1, instance.f2_p2, instance.f2_p1p2] #make an array with the observed values.
  #Be aware that every element in the "observed" array is a string
  
  for phenotype in observed #calculate the total number of individuals of the F2
      total_number += phenotype.to_i
  end

  #calculate the expected number of individuals for each phenotype of an F2 for independent genes.
  #H0 is that the genes are independent
  expected = [9.0/16.0*total_number, 3.0/16.0*total_number, 3.0/16.0*total_number, 1.0/16.0*total_number]
 
  merged = observed.zip expected #merge the two arrays to be able to iterate over both of them simultaneously
  
  for obs, exp in merged #iterate over "observed" and "expected" at the same time
      chi_square += (obs.to_i - exp)**2/exp #calculate the chi square value
  end
  
  p_value = Statistics2.chi2_x(3, chi_square) #calculate the p-value for the given chi square value and 3 degrees of liberty
  
  if p_value < 0.05 #if p-value < 0.05 the genes are linked
    for object in merged_gene_seed_stock_instances #change seed_stock names for their corresponding mutant_gene_id
      if instance.parent1 == object.seed_stock
        parent1_gene = object.mutant_gene_id #mutant gene name for parent 1
      elsif instance.parent2 == object.seed_stock
        parent2_gene = object.mutant_gene_id #mutant gene name for parent 2
      end 
    end
    
    #as the mutant genes in parent 1 and parent 2 are linked, we can fill the "linked_to" property in Merged_gene_seed_stock class
    
    for object in merged_gene_seed_stock_instances #for every object in the class
      if instance.parent1 == object.seed_stock #if it contains the seed_stock used as parent 1
        object.linked_to = parent2_gene #state that its mutant_gene is linked to the mutant_gene in parent 2
      elsif instance.parent2 == object.seed_stock #vice versa
        object.linked_to = parent1_gene
      end
      
    end
    
  end
  
end

#print the final report.

puts ""

puts "Final report"

for instance in merged_gene_seed_stock_instances
    unless instance.linked_to == nil
        puts "#{instance.mutant_gene_id} is linked to #{instance.linked_to}"
    end
    
end

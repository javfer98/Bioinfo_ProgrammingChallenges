require './annotated_gene.rb'


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


properties_array = [:@gene_id, :@gene_name, :@mutant_phenotype]
  
annotated_gene_instances = read_tsv("./gene_information.tsv", Annotated_gene, properties_array)


for instance in annotated_gene_instances 
    match_gene_id = Regexp.new(/A[Tt]\d[Gg]\d\d\d\d\d/)
    unless  match_gene_id.match(instance.gene_id)
        instance.gene_id = 'check_format'
        puts 'WARNING: wrong gene ID format. ID format set to "check_format"'
    end    
end


require 'rest-client'  

# Create a function called "fetch" that we can re-use everywhere in our code


#esta función es muy genérica, eso es bueno.
def fetch(url, headers = {accept: "*/*"}, user = "", pass="") #username and password by default are an empty string.
  response = RestClient::Request.execute({
    method: :get,
    url: url.to_s,
    user: user,
    password: pass,
    headers: headers})
  return response
 
  rescue RestClient::ExceptionWithResponse => e
    $stderr.puts e.inspect
    response = false
    return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code

  rescue RestClient::Exception => e
    $stderr.puts e.inspect
    response = false
    return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code

  rescue Exception => e
    $stderr.puts e.inspect
    response = false
    return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
end 







for instance in annotated_gene_instances
  
  #fetch the embl format ensembl data for each gene. find and retrieve the uniprot accession number
  res = fetch("http://www.ebi.ac.uk/Tools/dbfetch/dbfetch?db=ensemblgenomesgene&format=embl&id=#{instance.gene_id}");
  if res  # res is either the response object, or False, so you can test it with 'if'
    body = res.body  # get the "body" of the response
  
  #accession number can be in the following environments:
  # [Source:UniProtKB/TrEMBL;Acc:A0A178W846]
  # [Source:UniProtKB/Swiss-Prot;Acc:P47927]
    if body =~ /\[Source\:.+;Acc\:(.+)\]/   # [Source:UniProtKB/TrEMBL;Acc:A0A178W846]
      instance.uniprot_id = $1
    #  puts "uniprot accession number of the gene is #{uniprot}"
    #puts body
    #gene_name_regexp = Regexp.new(/locus_tag="([^"]+)"/)  # this is one way to do Regular Expressions in Ruby.  There are several!
    #match = gene_name_regexp.match(body)
    #if match
    #  gene_name = match[1]  # matches act like an array, so the first match is [1]
                            # (try for yourself, what is match[0]?)
    #  puts "the name of the gene is #{gene_name}"
    else
      begin  # use a "begin" block to handle errors
        puts "There was no gene name in this record"  # print a friendly message
  
        #raise fuerza a que ocurra una excepción
        #la excepción creada con raise triggers rescue.
        
        raise "this is an error" # raise an exception.
      rescue # some code to rescue the situation... for example, maybe a different regexp?
        puts "exiting gracefully"  # in this case, we are just going to stop trying
      end
    end
  end
  
  #fetch the fasta format dna sequence for each gene. retrieve it
  res = fetch("http://www.ebi.ac.uk/Tools/dbfetch/dbfetch?db=ensemblgenomesgene&format=fasta&id=#{instance.gene_id}");
  if res  # res is either the response object, or False, so you can test it with 'if'
    body = res.body  # get the "body" of the response
    instance.dna_sequence = body.strip #.strip removes \n from the beginning or end of the string
  #  puts instance.dna_sequence
  else
    puts "There was no DNA sequence in this record"
  end
    
  #fetch the fasta format protein sequence for each gene. retrieve it
  res = fetch("http://www.ebi.ac.uk/Tools/dbfetch/dbfetch?db=uniprotkb&format=fasta&id=#{instance.uniprot_id}&style=raw");
  if res  # res is either the response object, or False, so you can test it with 'if'
    body = res.body  # get the "body" of the response
    instance.protein_sequence = body.strip #.strip removes \n from the beginning or end of the string
  #  puts instance.protein_sequence
  else
    puts "There was no protein sequence in this record"
  end


puts "AGI_Locus        #{instance.gene_id}"
puts "GeneName            #{instance.gene_name}"
puts "Protein_ID       #{instance.uniprot_id}"
puts "DNA Sequence \n #{instance.dna_sequence}"
puts "Protein Sequence \n #{instance.protein_sequence}"
 
end




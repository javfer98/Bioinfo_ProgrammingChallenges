require './BetterHumanPatient.rb'
require './Disease.rb'


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


require 'wwood-rarff'

rel = Rarff::Relation.new('Parlamento')

IO.read("parlamento.xml") { |f|
  f.each_line { |line|
    data =  line.scan(/[0-9]{4}-[0-9]{2}-[0-9]{2}/)
    nome = line.scan(//)
    
    
    
        }
  
  }


rel.instances = [ [1.4, 'foo bar', 5, 'baz', "1900-08-08 12:12:12"],
  [20.9, 'ruby', 46, 'roc,ks', "2005-10-23 12:12:12"],
  [0, 'ruby', 46, 'rocks', "2001-02-19 12:12:12"],
  [68.1, 'stuff', 728, 'is cool', "1974-02-10 12:12:12"]]
rel.attributes[1].name = 'subject'
rel.attributes[4].name = 'birthday'
rel.attributes[4].type = 'DATE "yyyy-MM-dd HH:mm:ss"'
rel.to_arff

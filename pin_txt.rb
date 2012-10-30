require 'rubygems'
require 'open-uri'


outFile = File.new("parlamento.xml", "w")                            # Cria um novo ficheiro na raiz do projeto
outFile.puts("<PARLAMENTO>")                                         # Coloca a tag raiz <PARLAMENTO> no inicio do XML

for i in 1..5                                                        # ciclo for para iterar entre as várias páginas do datase

  @url = "http://www.parlamento.pt/DeputadoGP/Paginas/DetalheReuniaoPlenaria.aspx?BID=0000#{i}"


  #outFile = File.new("parlamento#{i}.xml", "w")                        # Cria um novo ficheiro na raiz do projeto
  outFile.puts("<sessao>")                                              # Coloca a tag sessão no ficheiro XML antes de cada sessão parlamentar

  open(@url) {|f|                                                       # abre o url e cria um bloco
      f.each_line {|line|
                    temp = line.scan(/ria de [0-9]{4}-[0-9]{2}-[0-9]{2}\./) # verifica se cada linha do url contem a informação especificada na expressão regular com o metodo "scan" e cria um array com a string
                 if temp.empty? == false                              
                    temp = temp.to_s.sub("[\"ria de ", "<data>")            # limpa o texto extraido da expressão regular e também os caracteres [" criados por se passar de array a string
                    temp = temp.sub(".\"]", "</data>")
                 end 
                 #unless temp.include? "[]"
                    outFile.puts(temp) 
                 #end 
                  
                    temp = line.scan(/(Biografia.*?["]\s[h])/) 
                 if temp.empty? == false
                    temp = temp.to_s.sub("[[\"Biografia de ", "<nome>")
                    temp = temp.sub("\\\" h\"]]", "</nome>")
                 end
                 #unless temp.include? "[]"
                   outFile.puts(temp)
                 #end 
                
                    temp = line.scan(/lblGP.*<\/sp/)
                 if temp.empty? == false    
                    temp = temp.to_s.sub("[\"lblGP\\\">", "<partido>")
                    temp = temp.sub("\/sp\"]", "/partido>")
                 end
                 #unless temp.include? "[]" 
                   outFile.puts(temp)
                 #end
                 
                    temp = line.scan(/Presenca">.*</) 
                 if temp.empty? == false   
                    temp = temp.to_s.sub("[\"Presenca\\\">", "<presenca>")
                    temp = temp.sub(")<\"]", "</presenca>" ).sub("(", '')
                 end
                 #unless temp.include? "[]" 
                   outFile.puts(temp)
                 #end
                
                    temp = line.scan(/Motivo">.*<\/s/)
                 if temp.empty? == false 
                    temp = temp.to_s.sub("[\"Motivo\\\">", "<motivo>")
                    temp = temp.sub("<\/s\"]", "</motivo>")
                 end
                 #unless temp.include? "[]"  
                   outFile.puts(temp) 
                 #end 
                 }
            outFile.puts("</sessao>")                                 # Coloca o fecho da tag </SESSAO> no fim da obtenção dos dados de cada sessão
            p f.base_uri                                              # Mostra informação do url que está a ser filtrado
            p f.charset                                                      
         }
 end                                                                 #fim de ciclo for 
outFile.puts("</PARLAMENTO>")                                        # Coloca o fecho da tag raiz </PARLAMENTO>
outFile.close                                                        # Fecha o ficheiro escrito

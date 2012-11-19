require 'rubygems'
require 'open-uri'

###########################################################
# ISPGaya 2012-2013                                       #
# PIN - Information Processing                            #
# Ricardo Taboada                                         #
# EI - 2930                                               #
#                                                         #
# This script serves the purpose of extrating relevant    #
# data from "Assembleia da Republica" dataset using       #
# regular expressions and build a valid structured xml    #
# file for further analysis.                              #
#                                                         #
###########################################################

# Cria um novo ficheiro na raiz do projeto
outFile = File.new("parlamento.xml", "w") 

# Coloca no topo do XML a informação sobre o mesmo
outFile.puts('<?xml version="1.0" encoding="UTF-8"?>')

# Coloca a tag raiz <PARLAMENTO> no inicio do XML                           
outFile.puts("<PARLAMENTO>")                                         

#Inicializa um contador para os urls processados e outro para as sessoes validas
urlCounter = 0
sessionCounter = 0
time = Time.new

temp1 = nil
cont = 0

for i in 401..600                                                         # ciclo for para iterar entre as várias páginas do datase
  inicio = time.inspect
  
  # Capturar o url para uma variavel "url"
  @url = "http://www.parlamento.pt/DeputadoGP/Paginas/DetalheReuniaoPlenaria.aspx?BID=#{i}"
  urlCounter += 1                                                       # incrementa o contador de urls
  puts @url                                                             # envia para a consola o url a ser processado
  outFile.puts"<!-- #{@url} -->"
                                                                
  #outFile = File.new("parlamento#{i}.xml", "w")                        # Cria um novo ficheiro na raiz do projeto
  outFile.puts("<session>")                                              # Coloca a tag sessão no ficheiro XML antes de cada sessão parlamentar

      open(@url) {|f|                                                       # abre o url e cria um bloco
          f.each_line {|line|
            
             ##########testa se a página existe#########
             temp1 = line.scan(/efectue nova pesquisa/)                 
             cont += 1                                                  # retorna a linha em que aparece a informação de página inexistente
             if temp1.empty? == false then                              # testa se encontrou a string na expressão regular
               #puts "break na linha #{cont}"
               cont =0                                                  # caso tenha encontrado coloca o contador de linahs a 0
               break                                                    # Interrompe o ciclo corrente de pesquisa uma vez que a página não existe
             end
             ###########################################
                  
                        temp = line.scan(/Reuni.*[0-9]{4}-[0-9]{2}-[0-9]{2}\./) # verifica se cada linha do url contem a informação especificada na expressão regular com o metodo "scan" e cria um array com a string
                     if temp.empty? == false      
                        sessionCounter += 1                                  # incrementa o contador de sessoes         
                        temp = temp.to_s.gsub(/.*[\s]/, "<date>")            # limpa o texto extraido da expressão regular e também os caracteres [" criados por se passar de array a string
                        temp = temp.sub(".\"]", "</date>")
                        outFile.puts(temp)
                     end 
                    
                      
                        temp = line.scan(/(Biografia.*?["]\s[h])/) 
                     if temp.empty? == false
                        temp = temp.to_s.sub("[[\"Biografia de ", "<name>")
                        temp = temp.sub("\\\" h\"]]", "</name>")
                        outFile.puts(temp)
                     end
                    
                    
                        temp = line.scan(/lblGP.*<\/sp/)
                     if temp.empty? == false    
                        temp = temp.to_s.sub("[\"lblGP\\\">", "<party>")
                        temp = temp.sub("\/sp\"]", "/party>")
                        outFile.puts(temp)
                     end
                    
                     
                        temp = line.scan(/Presenca">.*<\//) 
                     if temp.empty? == false   
                        temp = temp.to_s.sub("[\"Presenca\\\">", "<presence>")
                        temp = temp.sub("<\/\"]", "</presence>" )
                        outFile.puts(temp)
                     end
                    
                    
                        temp = line.scan(/Motivo">.*<\/s/)
                     if temp.empty? == false 
                        temp = temp.to_s.sub("[\"Motivo\\\">", "<motif>")
                        temp = temp.sub("<\/s\"]", "</motif>")
                        outFile.puts(temp)
                     end
                     
               
          }
          outFile.puts("</session>")                                 # Coloca o fecho da tag </SESSAO> no fim da obtenção dos dados de cada sessão
          #p f.base_uri                                             # Mostra informação do url que está a ser filtrado
          #p f.charset                                                      
     }
 end                                                                 #fim de ciclo for 

outFile.puts("</PARLAMENTO>")                                        # Coloca o fecho da tag raiz </PARLAMENTO>
outFile.close                                                        # Fecha o ficheiro escrito
time1 = Time.new
fim =  time1.inspect
puts "#{urlCounter} URL's analiysed. #{sessionCounter} valid sessions processed." 
puts "Begin processing #{inicio}, finalized #{fim}"

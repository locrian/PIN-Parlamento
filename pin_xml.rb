

text = ''

tagData = "<data>"
tagFechaData = "</data>"

lol = "texte".to_s

for i in 1..5
  outFile = File.new("parlamento#{i}.xml", "w")
  
  File.open("parlamento#{i}.txt").each do |line|
    
      line = line.to_s.sub("ria de ", tagData)
      line = line.sub(".", tagFechaData)
      
      line = line.sub("Motivo\">Motivo<", '')
      
      line = line.sub("Biografia de ", "<nome>")
      line = line.sub("\" h", "</nome>")
      
      line = line.sub("lblGP\">", "<partido>")
      line = line.sub("\/sp", "/partido>")
      
      line = line.sub("Presenca\">", "<presenca>")
      line = line.sub(")<", "</presenca>" ).sub("(", '')
      
      line = line.sub("Motivo\">", "<motivo>")
      line = line.sub("<\/s", "</motivo>")
      
      text << line
  end
  outFile.puts(text)
end
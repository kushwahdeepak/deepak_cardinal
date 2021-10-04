def getListOfGems
  raw = `bundle list`
  lines = raw.split("\n")
  names = lines.map{|l| l.split(" ")[1]}
  names.each{ |n| system('bundle info '+ n)}

end

puts getListOfGems
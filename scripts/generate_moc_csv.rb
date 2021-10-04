strVar = File.open(ARGV[0], &:readline)
puts strVar  #print headers
headers = strVar.split(',')
count = 0
(1..10).each do
  random_id = (0...8).map { (65 + rand(26)).chr }.join
  str = ""

  headers.each do |h|
    str << (h+'.'+random_id+"."+count.to_s+",").gsub('_', '.')
  end
  puts str.chop
  count += 1
end
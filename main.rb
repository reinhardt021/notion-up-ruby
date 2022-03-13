require 'dotenv'
Dotenv.load

file_path = ARGV[0]

if !file_path 
  puts "no file path given"
  return
end

puts "we can find the file here: ", file_path
file = File.open(file_path)

if !file
  puts "Not able to access file"
  return
end

data = file.read()
puts data
puts data.class
puts ENV["NOTION_VERSION"]
puts ENV["BEARER_TOKEN"]
puts ENV["DATABASE_ID"]

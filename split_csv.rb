#!/usr/bin/env ruby -w

filename = "/Users/rocconicholls/Downloads/total care patient list - Copy of PatientDemo_2Line.csv"
lines_per_file = 100
header_lines = 1

extension = File.extname(filename)
basename = File.basename(filename, extension)
puts "#{extension} - #{basename}"
header = []

File.foreach(filename).with_index do |line, idx|
  file_number = idx / lines_per_file
  next if file_number > 0
  new_file_name = "#{basename}(p#{file_number + 1})#{extension}"
  header << line if idx < header_lines

  if idx % lines_per_file == 0
    File.open(new_file_name, "w+") do |file|
      file.write header.join
    end
  else
    File.open(new_file_name, "a") do |file|
      file.write line
    end
  end

rescue => e
  puts "Error: #{e.class}"
end

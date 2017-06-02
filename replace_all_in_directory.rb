@array_to_find = [] # These arrays should be the same size, and the indices should match what is found/replaced
@array_to_replace = [] # These arrays should be the same size, and the indices should match what is found/replaced

Dir['./**/*rb'].each do |filename|
  next if File.directory?(filename)
  text = File.read(filename)
  @array_to_find.each_with_index do |find, replace_idx|
    text.gsub!(find, @array_to_replace[replace_idx])
  end
  File.open(filename, 'w') { |f| f.puts text }
end

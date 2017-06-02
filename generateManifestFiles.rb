manifest_directory = ARGV[0]

directories = Dir["#{manifest_directory}/*"]

directories.each do |folder|
  next unless File.directory?(folder)
  File.open("#{folder}/manifest.json", 'w') do |f|
    f.puts '['
    files = Dir.entries(folder).map do |file|
      next if [ '.', '..', '.DS_Store' ].include?(file)
      "  \"#{file}\""
    end.compact
    f.puts files.join(",\n")
    f.puts ']'
  end
end

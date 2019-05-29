contents = File.read("/Users/rocconicholls/code/games/remember_functions.rb")
contents.gsub!(/^#/, "\e[90m#")
contents.gsub!("\n", "\e[33m\n")
puts "\e[33m#{contents}\e[0m"

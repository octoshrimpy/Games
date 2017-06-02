def get_lines
  lines = []
  until (a = gets.chomp) == ""
    lines << a
  end
  puts "\e[33m------ vv Copy below this line vv ------\e[0m"
  puts "<p><strong>Instructions:</strong></p>"
  puts "<ol>"
  lines.each do |line|
    puts "<li>#{line}</li>"
  end
  puts "</ol>"
  puts "\e[33m------ ^^ Copy above this line ^^ ------\e[0m"
end

def html
  until gets.chomp == ""
    get_lines
  end
end

html

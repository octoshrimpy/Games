def color(str, *com)
  print "\e["
  com.each do |arg|
    print "#{arg}"
    print ";" if arg != com.last
  end
  print "m#{str}\e[0m"
  puts com
end
[3, 9, 4, 10]. each { |pre| (0..7).each { |suf| color("▒", (pre.to_s + suf.to_s).to_i) } }
color(" ", 31)
puts "--"
puts "\e[47m  \e[0m"
puts "--"

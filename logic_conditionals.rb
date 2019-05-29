require 'terminal-table'

perm_count = (ARGV[0] || 2).to_i

perms = [1, 0].repeated_permutation(perm_count)

def colorize(num)
  code = ["1", "true"].include?(num.to_s.gsub(" ", "")) ? "1;37;42" : "1;37;41"
  "\e[#{code}m#{num}\e[0m"
end

puts "\nIF &"
table = Terminal::Table.new do |t|
  t.style = { alignment: :center, padding_left: 0, padding_right: 0 }

  perms.each do |perm|
    val = eval("1 if (#{perm.map { |i| i == 0 ? "false" : "true" }.join(" && ")})") || 0
    t.add_row [colorize("   #{val}   ")] + perm.map { |i| colorize(" #{i} ") }
  end
end
puts table

puts "\nIF ||"
table = Terminal::Table.new do |t|
  t.style = { alignment: :center, padding_left: 0, padding_right: 0 }

  perms.each do |perm|
    val = eval("1 if (#{perm.map { |i| i == 0 ? "false" : "true" }.join(" || ")})") || 0
    t.add_row [colorize("   #{val}   ")] + perm.map { |i| colorize(" #{i} ") }
  end
end
puts table


puts "\nUNLESS &"
table = Terminal::Table.new do |t|
  t.style = { alignment: :center, padding_left: 0, padding_right: 0 }

  perms.each do |perm|
    val = eval("1 unless (#{perm.map { |i| i == 0 ? "false" : "true" }.join(" && ")})") || 0
    t.add_row [colorize("   #{val}   ")] + perm.map { |i| colorize(" #{i} ") }
  end
end
puts table

puts "\nUNLESS ||"
table = Terminal::Table.new do |t|
  t.style = { alignment: :center, padding_left: 0, padding_right: 0 }

  perms.each do |perm|
    val = eval("1 unless (#{perm.map { |i| i == 0 ? "false" : "true" }.join(" || ")})") || 0
    t.add_row [colorize("   #{val}   ")] + perm.map { |i| colorize(" #{i} ") }
  end
end
puts table

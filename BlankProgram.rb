require 'io/console'
require 'io/wait'

Thread.new do
  loop do
    #s = STDIN.getch.chomp #gets.chomp
    #s = STDIN.chomp
    s = STDIN.getch
    puts ""
    puts "You entered #{s}"
    exit if s == 'e'
  end
end

i = 0
loop do
  puts "Tick #{i}...\n"
  i += 1
  sleep 1
end

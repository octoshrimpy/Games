tick = 0
loop do
  sleep 0.8
  if tick > 0
    tick -= 1
    print "\a"
  end
  if Time.now.to_i % (15*60) == 0
    puts Time.now
    tick += 5
  end
end

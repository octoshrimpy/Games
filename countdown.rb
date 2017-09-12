number_counter = {}
total = 10000

total.times do |t|
  new_num = rand(10)
  number_counter[new_num] ||= 0
  number_counter[new_num] += 1

  number_counter.each do |num, count|
    print "#{num}: #{count}\n"
  end
end

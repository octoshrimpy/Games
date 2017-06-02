class Fixnum
  def rand_split(num_of_groups)
    set = Array.new(num_of_groups) {0}
    self.times { set[rand(0..(set.length - 1))] += 1 }
    set
  end
end

puts "#{100.rand_split(5)}"

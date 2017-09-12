def measure(&block)
  t = Time.now.to_f
  yield
  puts "Time taken: #{Time.now.to_f - t}"
end

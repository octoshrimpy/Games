a = [1, 3, 5]
b = [2, 4]

added_array = a.zip(b).map do |aa, bb|
  next if aa.nil? || bb.nil?
  aa + bb
end.compact
 puts n

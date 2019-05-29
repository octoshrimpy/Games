# weighted_percentages = [
#   [5, 79],
#   [20, 100],
#   [20, 20],
#   [5, 55],
#   [40, 80],
#   [10, 100],
# ]

weighted_percentages = [
  [5, 44],
  [6, 36],
  [4, 50],
  [3, 83],
  [4, 75],
  [2, 50],
  [4, 25],
  [3, 33],
  [5, 89],
  [3, 100],
  [3, 67],

  [3, 33],
  [3, 67],
  [4, 88],
  [13, 77],

  [2, 75],
  [2, 100],

  [5, 56],
  [8, 20],

  [3, 100],
  [4, 100],
  [11, 54],
]


total_weight = 100 * weighted_percentages.length
weights_sum = weighted_percentages.sum { |weight, percentage| weight }
total_score = weighted_percentages.sum do |weight, percentage|
  score = weight * (percentage / 100.to_f)
  puts "#{weight}% | #{percentage}% = #{score.round(2)}"
  score
end

puts "Total: #{total_score}/#{weights_sum}"

def normal_distribution
  distribution_times = 10
  low_num = 0
  high_num = 1000
  skew = 1

  rand_total = 0
  distribution_times.times {rand_total += rand(low_num + (high_num - low_num)) }
  rand_total / distribution_times
end

def linear_skewed_distribution
  min = 0
  max = 100
  ((rand - rand).abs * (1 + max - min) + min).floor
end

def print_vals(points_hash, order=:val)
  points_hash.keys.sort.each do |h_key|
    puts "#{h_key}: #{points_hash[h_key]}"
  end
end

scores = 100000.times.map {linear_skewed_distribution}

points = scores.each_with_object(Hash.new(0)) { |score,score_count| score_count[score] += 1 }
print_vals(points)
min_score = points.map {|s,c|s}.min
max_score = points.map {|s,c|s}.max
max_count = points.map {|s,c|c}.max

File.open("ruby_svg.svg", 'w') do |file|
file.write(
<<ENDSVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="#{min_score/2} 0 #{max_score * 1.2} #{max_count * 1.2}">
#{points.map { |score, score_count| "<circle cx='#{score + 5}' cy='#{max_count - score_count}' r='1' />" }.join("\n")}
</svg>
ENDSVG
)
end
`open -a Safari ruby_svg.svg`
#viewBox = <min-x> <min-y> <width> <height>

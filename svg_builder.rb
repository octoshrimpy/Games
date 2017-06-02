scores = 100000.times.map {
  distribution_times = 10
  low_num = 0
  high_num = 1000
  skew = 1

  rand_total = 0
  distribution_times.times {rand_total += rand(low_num + (high_num - low_num)) }
  rand_total / distribution_times
}
points = scores.each_with_object(Hash.new(0)) { |score,score_count| score_count[score] += 1 }
min_score = points.map {|s,c|s}.min
max_score = points.map {|s,c|s}.max
max_count = points.map {|s,c|c}.max

File.open("ruby_svg.svg", 'w') do |file|
file.write(
<<ENDSVG
<svg xmlns="http://www.w3.org/2000/svg" viewBox="#{min_score/2} 0 #{max_score + 20} #{max_count + 20}">
#{points.map { |score, score_count| "<circle cx='#{score + 5}' cy='#{max_count - score_count}' r='1' />" }.join("\n")}
</svg>
ENDSVG
)
end

#viewBox = <min-x> <min-y> <width> <height>

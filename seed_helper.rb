def random_user(count=1)
  users = User.all.sample(count)
  return users.first if count == 1
  users
end

def random_time_between_now_and(this_time, most_recent_allowed=1.second.ago)
  times = [most_recent_allowed, this_time].sort
  rand(times[0]..times[1])
end

def normal_dist_with_bias(min, max, bias)
  norm = rand * (max - min) + min
  mix = rand
  (norm * (1 - mix) + bias * mix).round
end

def linearly_biased_random_number(min, max)
  ((rand - rand).abs * (1 + max - min) + min).floor
end

@previous_string = ""
@previous_counts = []
def show_current_count(current_count_str, *max_counts)
  unless current_count_str == @previous_string
    puts ""
    @previous_counts = Array.new(max_counts.length) {1}
    @previous_counts[-1] = @previous_counts[-1] - 1
  end
  increment_next = true
  @previous_counts.reverse.each_with_index do |count, ridx|
    original_idx = @previous_counts.length - 1 - ridx
    count += 1 if increment_next
    increment_next = false
    if count > max_counts[original_idx]
      increment_next = true
      @previous_counts[original_idx] = 1
    else
      @previous_counts[original_idx] = count
    end
  end
  @previous_string = current_count_str
  count_strings = @previous_counts.length.times.map { |t| ": #{@previous_counts[t]} / #{max_counts[t]}" }.join("")
  print "\r#{' '*100}\r#{current_count_str}#{count_strings}  "
end
def show_checkpoint(str, did_succeed=true)
  color_code = did_succeed ? "32" : "31"
  print "\e[#{color_code}m#{str}\e[0m"
end


5.times do
  show_current_count("First Test", 5)
  sleep 0.4
end
5.times do
  3.times do
    show_current_count("Second Test", 3, 5)
    sleep 0.4
  end
end

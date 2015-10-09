def light(duration, range, percentage)
  hash = {range.to_s => duration}
  val = duration
  until range == 1
    range -= 1
    val *= percentage
    hash[range.to_s] = val
  end
  hash
end

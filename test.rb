20.times do
  p (Time.now.to_f*2).round(0) % 2
  sleep 0.5
end

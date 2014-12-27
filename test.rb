def rangeMapper(from_min, from_max, to_min, to_max, value)
  ((to_max - to_min) * (value - from_min)).to_f / (from_max - from_min) + to_min
end

p 1.to_f/rangeMapper(0, 100, 0, 13, 80)


# 1.to_f/(bps)
# 20bps = 1/20 = 0.05
# 15bps = 1/15 = 0.0666
# 11bps = 1/11 = 0.09090909090
# 10bps = 1/10 = 0.1
# 5bps = 1/5 = 0.2
# 4bps = 1/4 = 0.25
# 3bps = 1/3 = 0.333
# 2bps = 1/2 = 0.5
# 1bps = 1/1 = 1

# goal 80 = 11 bps = 0.090909090909

require 'pry-rails'
$storage = {}

def add_speed(ping, down, up, type)
  $storage[type] ||= []
  $storage[type] << {ping: ping, down: down, up: up}
end

def get_average
  $storage.each do |type, type_array|
    count = 0
    ping_total = 0.000
    down_total = 0.000
    up_total = 0.000
    type_array.each do |storage|
      count += 1
      ping_total += storage[:ping].to_f
      down_total += storage[:down].to_f
      up_total += storage[:up].to_f
      # print "      "
      # p storage
    end
    ping_avg = ping_total / count
    down_avg = down_total / count
    up_avg = up_total / count
    puts "#{type}: {ping: #{ping_avg}, down: #{down_avg}, up: #{up_avg}}"
  end
end

add_speed(16, 9.84, 4.92, 'wifi')
add_speed(20, 60.16, 6.08, 'wifi')
add_speed(10, 59.28, 6.33, 'wifi')
add_speed(20, 56.84, 6.29, 'wifi')
add_speed(17, 58.47, 6.07, 'wifi')

add_speed(21, 59.50, 6.06, 'direct-rosewill')
add_speed(18, 59.35, 6.19, 'direct-rosewill')
add_speed(15, 59.37, 6.13, 'direct-rosewill')
add_speed(30, 59.43, 6.14, 'direct-rosewill')
add_speed(16, 59.47, 6.07, 'direct-rosewill')

add_speed(24, 59.03, 6.10, 'direct-home-ecf8')
add_speed(21, 59.07, 6.04, 'direct-home-ecf8')
add_speed(22, 58.90, 6.12, 'direct-home-ecf8')
add_speed(18, 53.51, 6.06, 'direct-home-ecf8')
add_speed(15, 57.68, 6.08, 'direct-home-ecf8')

add_speed(20, 47.49, 2.79, 'Orca')

add_speed(31, 81.99, 11.97, 'New Direct')
add_speed(31, 87.09, 12.23, 'New Direct')
add_speed(31, 85.92, 12.38, 'New Direct')
add_speed(31, 86.75, 12.31, 'New Direct')
add_speed(31, 84.93, 12.02, 'New Direct')

add_speed(31, 16.71, 11.13, 'New Wifi')
add_speed(31, 13.01, 3.00, 'New Wifi')
add_speed(31, 14.43, 3.03, 'New Wifi')
add_speed(31, 15.31, 12.10, 'New Wifi')
add_speed(31, 19.20, 12.06, 'New Wifi')

get_average

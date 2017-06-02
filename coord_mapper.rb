def show(str)
  "\e[31m#{str}\e[0m"
end

def coord_diff(from, to)
  x1, y1 = from
  x2, y2 = to
  [x1-x2, y1-y2]
end

def get_coords_between_points(loc, last_loc, distance_per_block)
  lat, lng = loc.is_a?(String) ? loc.split(',').map(&:to_f) : loc.map(&:to_f)
  last_lat, last_lng = last_loc.is_a?(String) ? last_loc.split(',').map(&:to_f) : last_loc.map(&:to_f)
  d_lat = (lat - last_lat).abs
  d_lng = (lng - last_lng).abs
  lat_laps = (d_lat / distance_per_block).round
  lat_laps = lat_laps.odd? ? lat_laps : lat_laps + 1
  lng_laps = (d_lng / distance_per_block).round
  lng_laps = lng_laps.odd? ? lng_laps : lng_laps + 1
  coord_list = []
  lat_laps.times do |lap_dx|
    x = lat < last_lat ? (lat + (lap_dx * distance_per_block)) : (lat - (lap_dx * distance_per_block))
    coords = []
    lng_laps.times do |lap_dy|
      y = lng < last_lng ? (lng + (lap_dy * distance_per_block)) : (lng - (lap_dy * distance_per_block))
      coords << [x, y]
    end
    coords.reverse! if lap_dx.odd?
    coord_list += coords
  end
  coord_list
end
first = "40.53696445738481,-111.97682048212647"
first_lat, first_lng = first_coord = first.split(',').map(&:to_f)
last = "40.5441995,-111.984185"
last_lat, last_lng = last_coord = last.split(',').map(&:to_f)
coords = get_coords_between_points(first, last, 0.0005)
# puts show(coord_diff(first_coord, coords.first))
puts show "[#{coords.map(&:to_s).join(',')}]"
# coords.each do |coord|
#   puts "#{coord}"
# end
# puts show(coord_diff(last_coord, coords.last))

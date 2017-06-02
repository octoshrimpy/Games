require "minitest/autorun"

module Tester
  def coords_between(first, last)
    x1, y1 = first
    x2, y2 = last
    dx = (x1 - x2).abs + 1
    dy = (y1 - y2).abs + 1
    coord_list = []
    dx.times do |tx|
      x = x1 < x2 ? (x1 + tx) : (x1 - tx)
      coords = []
      dy.times do |ty|
        y = y1 < y2 ? (y1 + ty) : (y1 - ty)
        coords << [x, y]
      end
      coords.reverse! if tx.odd?
      coord_list += coords
    end
    coord_list
  end
end

class TestRunner < Minitest::Test
  include Tester

  def run_list_against_each_test(first, last)
    coord_list = coords_between(first, last)

    check_starts_at_beginning_coord(first, coord_list)
    check_includes_ending_coord(last, coord_list)
    check_contains_all_points([first, last], coord_list)
    check_moves_only_one_space_at_a_time(coord_list)
  end

  def check_starts_at_beginning_coord(first, list)
    assert_equal(list.first, first, "Does not start at beginning coordinate.")
  end
  def check_includes_ending_coord(last, list)
    assert_includes(list, last, "Does not contain ending coordinate.")
  end
  def check_contains_all_points(coords, list)
    x1, y1, x2, y2 = coords.flatten
    x_values = x1 > x2 ? (x2..x1) : (x1..x2)
    y_values = y1 > y2 ? (y2..y1) : (y1..y2)
    each_point_list = x_values.map { |x| y_values.map { |y| [x, y] } }.flatten(1)
    assert_equal((each_point_list - list).empty?, true, "Does not contain all points.")
  end
  def check_moves_only_one_space_at_a_time(list)
    max_diff = 0
    max_diff_coords = []
    previous_coord = list.first
    list.each do |coord|
      x1, y1 = previous_coord
      x2, y2 = coord
      coord_diff = ((x1 - x2).abs + (y1 - y2).abs)
      if coord_diff > max_diff
        max_diff = coord_diff
        max_diff_coords = [previous_coord, coord]
      end
      previous_coord = coord
    end
    assert_equal(1, max_diff, "Cannot move more than 1 space at a time. Moved from (#{max_diff_coords.first.join(', ')}) to (#{max_diff_coords.last.join(', ')})")
  end

  def test_from_zero_square
    run_list_against_each_test([0, 0], [3, 3])
  end
  def test_negative
    run_list_against_each_test([0, 0], [-3, 3])
  end
  def test_irregular
    run_list_against_each_test([2, 9], [-3, 7])
  end
  def test_line
    run_list_against_each_test([1, 1], [1, 7])
  end

end

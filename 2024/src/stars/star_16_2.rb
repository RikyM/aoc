# frozen_string_literal: true

require 'colorize'
require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(16, 2)
  end

  def run(input)
    row = 0
    walls = Set.new
    reindeer = nil
    end_tile = nil
    input.each_line do |line|
      line.each_char.with_index do |char, column|
        case char
        when /#/
          walls << Coordinate.new(row, column)
        when /S/
          reindeer = Coordinate.new(row, column)
        when /E/
          end_tile = Coordinate.new(row, column)
        else
          # Empty space
        end
      end
      row += 1
    end

    corners = Set.new
    (1..walls.map(&:row).max).each do |row|
      (1..walls.map(&:column).max).each do |column|
        c = Coordinate.new(row, column)
        neighs_dirs = c.oriented_neighs
                       .filter{|dir, coord| not walls.include?(coord)}
                       .map{|dir, _| dir}
        if neighs_dirs.size != 2 or (not opposite_dir?(*neighs_dirs))
          corners << c
        end
      end
    end


    # TODO This is slow as fuck. Probably scanning the space row by row is better
    adj = Hash.new {|h,k| h[k] = {}}
    corners.each do |c|
      Coordinate.four_directions.each do |dir|
        nearest_wall, distance_wall = *(Star.nearest_in_to walls, c, dir)
        nearest_corner, distance_corner = *(Star.nearest_in_to corners, c, dir)

        if (not nearest_corner.nil?) and distance_corner < distance_wall
          adj[c][dir] = {coord: nearest_corner, distance: distance_corner}
        end
      end
    end

    costs = {[:right, reindeer] => 0}
    reverse_costs = Hash.new {|h,k| h[k] = Hash.new{|hi,ki| hi[ki] = Set.new}}
    to_visit = [{reindeer: reindeer, direction: :right}]

    min_cost = 10000000000000000000000000000000000000000000000000
    until to_visit.empty?
      visiting = to_visit.pop
      r = visiting[:reindeer]
      d = visiting[:direction]
      k = [d, r]

      current_cost = costs[k]
      next if current_cost > min_cost

      step = adj[r][d]
      unless step.nil?
        total_cost = current_cost + step[:distance]
        dn = [d, step[:coord]]
        if ((not costs.include?(dn)) or (costs.include? dn and costs[dn] >= total_cost)) and total_cost <= min_cost
          costs[dn] = total_cost
          to_visit << {reindeer: step[:coord], direction: d}
          reverse_costs[dn][total_cost] << k
          min_cost = total_cost if step[:coord] == end_tile
        end
      end

      Coordinate.four_directions.each do |dir|
        next if dir == d
        total_cost = current_cost + 1000

        dn = [dir, r]
        if ((not costs.include?(dn)) or (costs.include? dn and costs[dn] >= total_cost)) and total_cost <= min_cost
          costs[dn] = total_cost
          to_visit << {reindeer: r, direction: dir}
          reverse_costs[dn][total_cost] << k
        end
      end
    end

    on_path = Set.new
    to_visit = reverse_costs.keys.filter{|x| x[1] == end_tile}
    to_visit = [to_visit.min_by{|t| reverse_costs[t].keys.min}]
    visited = Set.new
    until to_visit.empty?
      coord = to_visit.pop
      coord_coord = coord[1]
      on_path << coord[1]

      min_cost = reverse_costs[coord].keys.min
      reverse_costs[coord][min_cost].each do |e|
        ec = e[1]
        ed = e[0]
        until ec == coord_coord
          on_path << ec
          ec = ec.move(ed)
        end
        to_visit << e
      end
      visited << coord
    end

    on_path.size
  end

  def opposite_dir?(a, b)
    ((a == :up and b == :down) or
      (b == :down and a == :up) or
      (a == :right and b == :left) or
      (a == :left and b == :right))
  end

  def self.nearest_in_to(set, coord, dir)
    if dir == :up
      nearest = set.filter{|c| c.column == coord.column and c.row < coord.row}.max_by(&:row)
      return nearest.nil? ? [nil, -1] : [nearest, coord.row - nearest.row]
    end
    if dir == :down
      nearest = set.filter{|c| c.column == coord.column and c.row > coord.row}.min_by(&:row)
      return nearest.nil? ? [nil, -1] : [nearest, nearest.row - coord.row]
    end
    if dir == :left
      nearest = set.filter{|c| c.row == coord.row and c.column < coord.column}.max_by(&:column)
      return nearest.nil? ? [nil, -1] : [nearest, coord.column - nearest.column]
    end
    if dir == :right
      nearest = set.filter{|c| c.row == coord.row and c.column > coord.column}.min_by(&:column)
      return nearest.nil? ? [nil, -1] : [nearest, nearest.column - coord.column]
    end
  end
end

# frozen_string_literal: true

require 'colorize'
require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(16, 1)
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


    #(walls.map(&:row).max+1).times do |row|
    #  (walls.map(&:column).max.+1).times do |column|
    #    c = Coordinate.new(row, column)
    #    if walls.include?(Coordinate.new(row, column))
    #      print '#'.colorize(:red)
    #    elsif corners.include?(Coordinate.new(row, column))
    #      print '.'.colorize(:light_blue)
    #    else
    #      print '.'.colorize(:light_black)
    #    end
    #  end
    #  puts
    #end

    #adj = Hash.new {|h,k| h[k] = []}

    #corners.each do |c|
    #  Coordinate.four_directions.each do |dir|
    #    nearest_wall, distance_wall = *(nearest_in_to walls, c, dir)
    #    nearest_corner, distance_corner = *(nearest_in_to corners, c, dir)

    #    if (not nearest_corner.nil?) and distance_corner < distance_wall
    #      adj[c] << {corner: nearest_corner, distance: distance_corner, direction: dir}
    #    end
    #  end
    #end

    #puts('breakpoint')
    costs = {reindeer => 0}
    to_visit = [{reindeer: reindeer, direction: :right}]

    until to_visit.empty?
      visiting = to_visit.pop
      next if visiting[:reindeer] == end_tile

      #ns = adj[visiting[:reindeer]]
      #ns.each do |neigh|
      #  corner = neigh[:corner]
      #  cost = neigh[:distance] + rotation_cost_from_to(visiting[:direction], neigh[:direction])
      #  total_cost = cost + costs[visiting[:reindeer]]
      #  if (not costs.include?(corner)) or costs[corner] > total_cost
      #    costs[corner] = cost + costs[visiting[:reindeer]]
      #    to_visit << {reindeer: corner, direction: neigh[:direction]}
      #  end
      #end

      visiting[:reindeer].oriented_neighs
              .filter{|d, n| not walls.include? n}
              .each_pair do |d, n|
                cost = 1 + rotation_cost_from_to(visiting[:direction], d)
                total_cost = cost + costs[visiting[:reindeer]]
                if (not costs.include?(n)) or (costs.include? n and costs[n] > total_cost)
                  costs[n] = cost + costs[visiting[:reindeer]]
                  to_visit << {reindeer: n, direction: d}
                end
              end
    end

    costs[end_tile]
  end

  def rotation_cost_from_to(from, to)
    return 0 if from == to
    1000
  end

  def opposite_dir?(a, b)
    res = ((a == :up and b == :down) or
      (b == :down and a == :up) or
      (a == :right and b == :left) or
      (a == :left and b == :right))
    res
  end

  def nearest_in_to(set, coord, dir)
    if dir == :up
      nearest = set.filter{|c| c.column == coord.column and c.row < coord.row}.max_by(&:row)
      return nearest.nil? ? [nil, -1] : [nearest, coord.row - nearest.row]
    end
    if dir == :down
      nearest = set.filter{|c| c.column == coord.column and c.row > coord.row}.min_by(&:row)
      return nearest.nil? ? [nil, -1] : [nearest, nearest.row - coord.row]
    end
    if dir == :left
      nearest = set.filter{|c| c.row == coord.row and c.column < coord.column}.max_by(&:row)
      return nearest.nil? ? [nil, -1] : [nearest, coord.column - nearest.column]
    end
    if dir == :right
      nearest = set.filter{|c| c.row == coord.row and c.column > coord.column}.max_by(&:row)
      return nearest.nil? ? [nil, -1] : [nearest, nearest.column - coord.column]
    end
  end
end
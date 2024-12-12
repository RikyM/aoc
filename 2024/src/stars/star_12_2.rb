# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(12, 2)
  end

  def run(input)
    plants = Hash.new { |hash, key| hash[key] = Set.new }

    #garden = Grid.new
    row = 0
    input.each_line do |line|
      line.chars.each.with_index do |plant, column|
        plants[plant] << Coordinate.new(row, column)
      end
      row += 1
    end

    res = 0
    plants.each_pair do |plant, coords|
      until coords.empty?
        coords.first
        score = score_group_of(coords.first, coords)
        res += score
      end
    end

    res
  end

  private

  def score_group_of(coord, coords)
    to_see = [coord]
    seen = Set.new
    edges = Set.new

    until to_see.empty?
      c = to_see.pop
      next if seen.include?(c)

      c.oriented_neighs.each_pair do |direction, n|
        next if seen.include?(n)
        if coords.include?(n)
          to_see << n
        else
          edges << Edge.of_coord_going(c, direction)
        end
      end

      seen << c
    end

    coords.subtract(seen)
    count_sides(edges) * seen.size
  end

  def count_sides(edges)
    seen = Set.new

    res = 0
    edges.each do |e|
      next if seen.include?(e)

      e.movable_directions.each do |direction|
        n = e.move(direction)
        while edges.include?(n)
          seen << n
          n = n.move(direction)
        end
      end

      seen << e
      res += 1
    end

    res
  end
end

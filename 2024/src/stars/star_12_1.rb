# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(12, 1)
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

    edges = 0

    until to_see.empty?
      c = to_see.pop
      next if seen.include?(c)

      c.neighs.each do |n|
        next if seen.include?(n)
        if coords.include?(n)
          to_see << n
        else
          edges += 1
        end
      end

      seen << c
    end

    coords.subtract(seen)
    edges * seen.size
  end
end

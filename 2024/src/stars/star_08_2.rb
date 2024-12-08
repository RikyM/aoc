# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(8, 2)
  end

  def run(input)
    row = 0
    antennas = Hash.new {|h,k| h[k] = []}

    input.each_line do |line|
      next if line.empty?
      line.each_char.with_index do |name, column|
        next if name == ?. or name == ?#
        antennas[name] << Coordinate.new(row, column)
      end

      row += 1
    end
    grid_size = row

    antinodes = Set.new
    antennas.each_pair do |name, coords|
      coords.combination(2).each do |pair|
        an = Star.antinode_of(*pair)
        node = an[:base]
        delta = an[:delta]

        if node.column >= grid_size and delta.column < 0
          node += delta until node.column < grid_size
        elsif node.column < 0 and delta.column > 0
          node += delta until node.column >= 0
        end

        while node.in_range?(0...grid_size)
          antinodes << node
          node = node + delta
        end

      end
    end

    antinodes.size
  end

  private

  def self.antinode_of(a0, a1)
    up, down = [a0, a1].sort_by{:row}

    delta_y = down.row - up.row
    delta_x = down.column - up.column

    if delta_y == 0
      base_row = up.row
      base_column = delta_x > 0 ? up.column % delta_x : down.column % (-delta_x)
    else
      base_row = up.row % delta_y
      base_column = up.column - delta_x * (up.row / delta_y)
    end

    {
      base: Coordinate.new(base_row, base_column),
      delta: Coordinate.new(delta_y, delta_x)
    }
  end
end

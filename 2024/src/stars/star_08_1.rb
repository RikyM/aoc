# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(8, 1)
  end

  def run(input)
    row = 0
    antennas = Hash.new {|h,k| h[k] = []}

    input.each_line do |line|
      next if line.empty?
      grid_size = line.size

      line.each_char.with_index do |name, column|
        next if name == ?. or name == ?#
        antennas[name] << Coordinate.new(row, column)
      end

      row += 1
    end

    antinodes = Set.new
    antennas.each_pair do |name, coords|
      coords.combination(2).each do |pair|
        Star.antinodes_of(*pair).each{|node| antinodes << node}
      end
    end

    antinodes.filter {|coord| coord.in_range?(0...row)}
             .size
  end

  private

  def self.antinodes_of(a0, a1)
    up, down = [a0, a1].sort_by{:row}

    [
      Coordinate.new(
         up.row - (down.row - up.row),
         up.column - (down.column - up.column)),
      Coordinate.new(
        down.row + (down.row - up.row),
         down.column + (down.column - up.column))
    ]
  end
end

# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(10, 2)
  end

  def run(input)
    grid = []
    zeroes = []
    y = 0
    input.each_line do |line|
      next if line.empty?
      row = line.chars.map(&:to_i)

      row.each.with_index{|h, x| zeroes << Coordinate.new(y, x) if h == 0}
      grid << row

      y += 1
    end

    zeroes.map{|z| explore grid, z, 0}
          .sum
  end

  private

  def explore(grid, current_position, current_height)
    return 1 if current_height == 9

    current_position.neighs
      .filter{|n| not n.nil? and n.in_range?(0...grid.size)}
      .filter{|n| grid[n.row][n.column] == current_height + 1}
      .map{|n| explore grid, n, current_height+1}
      .sum
  end
end

# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'

class Robot
  def initialize(position, velocity)
    @position = position
    @velocity = velocity
  end

  def move(seconds)
    @position.+(@velocity, seconds)
  end
end

class Star < SuperStar
  def initialize n_rows=103, n_cols=101
    super(14, 1)

    @n_rows = n_rows
    @n_cols = n_cols
  end

  def run(input)
    robots = []
    wrap_limits = Coordinate.new(@n_rows, @n_cols)
    input.each_line do |line|
      pos, vel = line.split.map{|e| Coordinate.new( *e.split(?=)
                                                       .last
                                                       .split(?,)
                                                       .map(&:to_i).reverse)}
      pos.wrap_around = wrap_limits
      r = Robot.new(pos, vel)
      robots << r
    end

    new_pos = robots.map{|r| r.move(100)}

    quadrant_line_row = wrap_limits.row / 2
    quadrant_line_column = wrap_limits.column / 2
    [
      new_pos.count{|p| p.row < quadrant_line_row && p.column < quadrant_line_column},
      new_pos.count{|p| p.row < quadrant_line_row && p.column > quadrant_line_column},
      new_pos.count{|p| p.row > quadrant_line_row && p.column < quadrant_line_column},
      new_pos.count{|p| p.row > quadrant_line_row && p.column > quadrant_line_column}
    ].reduce(:*)
  end
end

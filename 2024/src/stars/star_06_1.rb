# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'
require_relative '../lib/visitor'

require 'set'

class Star < SuperStar
  def initialize
    super(6, 1)
  end

  def run(input)
    obstacles = Set.new
    guard_position = nil
    guard_orientation = :up

    row = 0
    input.each_line do |line|
      line.each_char.with_index do |char, column|
        if char == '#'
          obstacles << Coordinate.new(row, column)
        elsif char == '^'
          guard_position = Coordinate.new(row, column)
        end
      end

      row += 1
    end

    Visitor.new(row, obstacles, guard_position, guard_orientation).visit.size
  end

  private

  def next_obstacle(obstacles, guard_position, guard_orientation)
    case guard_orientation
    when :up
      obstacles.filter{|o| o.column == guard_position.column && o.row < guard_position.row}
               .max_by{|o| o.row}
    when :right
      obstacles.filter{|o| o.row == guard_position.row && o.column > guard_position.row}
               .min_by{|o| o.column}
    when :down
      obstacles.filter{|o| o.column == guard_position.column && o.row > guard_position.row}
               .min_by{|o| o.row}
    when :left
      obstacles.filter{|o| o.row == guard_position.row && o.column < guard_position.row}
               .max_by{|o| o.column}
    else
      raise "Unknown guard orientation: #{guard_orientation}"
    end
  end

  def rotate(guard_orientation)
    case guard_orientation
    when :up
      :right
    when :right
      :down
    when :down
      :left
    when :left
      :up
    else
      raise "Unknown guard orientation: #{guard_orientation}"
    end
  end

  def move_guard(guard_position, guard_orientation, next_obstacle)
    case guard_orientation
    when :up
      guard_position.move_until(next_obstacle, :guard_orientation)
      guard_position.set!(next_obstacle.row+1, next_obstacle.column)
    when :right
      steps = next_obstacle.column - guard_position.column - 1
      guard_position.set!(next_obstacle.row, next_obstacle.column-1)
    when :down
      steps =  next_obstacle.row - guard_position.row - 1
      guard_position.set!(next_obstacle.row-1, next_obstacle.column)
    when :left
      steps = guard_position.column - next_obstacle.column - 1
      guard_position.set!(next_obstacle.row, next_obstacle.column+1)
    else
      raise "Unknown guard orientation: #{guard_orientation}"
    end

    steps
  end
end

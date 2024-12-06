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


    count = 0
    potential_obstacles = Visitor.new(row, obstacles, guard_position, guard_orientation).visit
    potential_obstacles.each do |obstacle|
      obstacles << obstacle

      if loop?(obstacles, guard_position.clone, guard_orientation.clone)
        count += 1
      end

      obstacles.delete(obstacle)
    end

    count
  end

  def self.next_obstacle(obstacles, guard_position, guard_orientation)
    case guard_orientation
    when :up
      obstacles.filter{|o| o.column == guard_position.column && o.row < guard_position.row}
               .max_by{|o| o.row}
    when :right
      obstacles.filter{|o| o.row == guard_position.row && o.column > guard_position.column}
               .min_by{|o| o.column}
    when :down
      obstacles.filter{|o| o.column == guard_position.column && o.row > guard_position.row}
               .min_by{|o| o.row}
    when :left
      obstacles.filter{|o| o.row == guard_position.row && o.column < guard_position.column}
               .max_by{|o| o.column}
    else
      raise "Unknown guard orientation: #{guard_orientation}"
    end
  end

  def self.move_guard(guard_orientation, next_obstacle)
    case guard_orientation
    when :up
      Coordinate.new(next_obstacle.row+1, next_obstacle.column)
    when :right
      Coordinate.new(next_obstacle.row, next_obstacle.column-1)
    when :down
      Coordinate.new(next_obstacle.row-1, next_obstacle.column)
    when :left
      Coordinate.new(next_obstacle.row, next_obstacle.column+1)
    else
      raise "Unknown guard orientation: #{guard_orientation}"
    end
  end

  private

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

  def loop?(obstacles, guard_position, guard_orientation)
    visited = Set.new
    visited << [guard_position, guard_orientation]

    loop do
      obstacle = Star.next_obstacle(obstacles, guard_position, guard_orientation)
      return false if obstacle.nil?

      guard_position = Star.move_guard(guard_orientation, obstacle)
      guard_orientation = rotate(guard_orientation)

      pos = [guard_position, guard_orientation]
      return true if visited.include?(pos)

      visited << pos
    end
  end
end

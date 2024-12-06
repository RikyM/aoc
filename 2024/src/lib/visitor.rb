# frozen_string_literal: true

class Visitor

  def initialize(row_size, obstacles, starting_position, starting_direction)
    @row_size = row_size
    @obstacles = obstacles
    @guard_position = starting_position
    @guard_direction = starting_direction
  end

  def visit()
    visited = Set.new
    visited << @guard_position

    loop do
      new_pos = @guard_position.move(@guard_direction)

      if @obstacles.include?(new_pos)
        @guard_direction = rotate(@guard_direction)
      elsif new_pos.row >= @row_size or new_pos.column >= @row_size or new_pos.row < 0 or new_pos.column < 0
        break
      else
        visited << new_pos
        @guard_position = new_pos
      end
    end

    visited
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

  def steps_to_exit(guard_position, guard_orientation, map_size)
    case guard_orientation
    when :up
      guard_position.row + 1
    when :right
      map_size - guard_position.column
    when :down
      map_size - guard_position.row
    when :left
      guard_position.column + 1
    else
      raise "Unknown guard orientation: #{guard_orientation}"
    end
  end

end

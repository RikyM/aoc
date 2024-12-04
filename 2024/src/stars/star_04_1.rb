# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(4, 1)

    @target_word = 'XMAS'.chars
    @last_letter = 3
  end

  def run(input)
    grid = Grid.new
    input.each_line do |line|
      grid << line
    end

    result = 0
    grid.size.times do |row|
      grid.size.times do |column|
        result += search grid, row, column
      end
    end

    result
  end

  private

  def search(grid, row, column)
    c = Coordinate.new(row, column)
    Coordinate.all_directions
              .count {|direction| search_direction(grid, c.set!(row, column), 0, direction)}
  end

  def search_direction(grid, coordinate, target_letter, direction)
    letter = grid.get(coordinate)

    return false if letter != @target_word[target_letter]
    return true if target_letter == @last_letter

    coordinate.move! direction
    search_direction(grid, coordinate, target_letter+1, direction)
  end
end

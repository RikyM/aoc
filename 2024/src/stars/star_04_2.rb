# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(4, 2)

    @central_letter = ?A
    @corner_letters = [?M, ?S]
  end

  def run(input)
    grid = Grid.new
    input.each_line do |line|
      grid << line
    end

    result = 0
    grid.size.times do |row|
      grid.size.times do |column|
        result += 1 if search grid, row, column
      end
    end

    result
  end

  private

  def search(grid, row, column)
    coord = Coordinate.new(row, column)

    central = grid.get coord
    return false if central != @central_letter

    corners = [
      grid.get(coord.move :up_left),
      grid.get(coord.move :down_right)]
    return false unless corners_are_right? corners

    corners = [
      grid.get(coord.move :up_right),
      grid.get(coord.move :down_left)]
    return false unless corners_are_right? corners

    true
  end

  def corners_are_right? corners
    corners.filter{|x| not x.nil?}.sort == @corner_letters
  end
end

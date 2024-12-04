# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar


  def initialize
    super(4, 1)

    @target_word = 'XMAS'.chars
    @last_letter = 3
    @found = []
  end

  def run(input)
    grid = []
    input.each_line do |line|
      grid << line
    end

    result = 0
    grid.size.times do |row|
      grid.size.times do |column|
        s = search grid, row, column
        result += s
      end
    end

    result
  end

  private

  def search(grid, row, column)
    searches = [search_up(grid, row, column, 0),
                search_up_right(grid, row, column, 0),
                search_right(grid, row, column, 0),
                search_right_down(grid, row, column, 0),
                search_down(grid, row, column, 0),
                search_down_left(grid, row, column, 0),
                search_left(grid, row, column, 0),
                search_left_up(grid, row, column, 0)]

    searches.count{|x| x}
  end

  def search_up(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_up(grid, row-1, column, target_letter+1)
  end

  def search_up_right(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_up_right(grid, row-1, column+1, target_letter+1)
  end

  def search_right(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_right(grid, row, column+1, target_letter+1)
  end

  def search_right_down(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_right_down(grid, row+1, column+1, target_letter+1)
  end

  def search_down(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_down(grid, row+1, column, target_letter+1)
  end

  def search_down_left(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_down_left(grid, row+1, column-1, target_letter+1)
  end

  def search_left(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_left(grid, row, column-1, target_letter+1)
  end

  def search_left_up(grid, row, column, target_letter)
    letter = get(grid, row, column)

    return false if letter != @target_word[target_letter]
    @found << [row, column] if target_letter == @last_letter
    return true if target_letter == @last_letter

    search_left_up(grid, row-1, column-1, target_letter+1)
  end

  def get(grid, row, column)
    return ?. if row < 0 || column < 0
    begin
      grid[row][column]
    rescue => e
      ?.
    end
  end
end

puts Star.new.help_the_elves
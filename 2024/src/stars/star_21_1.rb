# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'

class NumericKeypad
  def initialize
    @buttons = {
      '7' => Coordinate.new(0, 0),
      '8' => Coordinate.new(0, 1),
      '9' => Coordinate.new(0, 2),

      '4' => Coordinate.new(1, 0),
      '5' => Coordinate.new(1, 1),
      '6' => Coordinate.new(1, 2),

      '1' => Coordinate.new(2, 0),
      '2' => Coordinate.new(2, 1),
      '3' => Coordinate.new(2, 2),

      '0' => Coordinate.new(3, 1),
      'A' => Coordinate.new(3, 2),
    }
    @selected_coord = @buttons['A']
  end

  def move_to(n)
    target_coord = @buttons[n]
    dr = target_coord.row - @selected_coord.row
    dc = target_coord.column - @selected_coord.column
    @selected_coord = target_coord

    if dr <= 0 and dc <= 0    # up left
      if target_coord.row - dr == 3 and target_coord.column == 0
        (?^ * -dr) + (?< * -dc) + 'A'
      else
        (?< * -dc) + (?^ * -dr) + 'A'
      end
    elsif dr <= 0 and dc > 0  # up right
      (?^ * -dr) + (?> * dc) + 'A'
    elsif dr > 0 and dc <= 0  # down left
      (?v * dr) + (?< * -dc) + 'A'
    elsif dr > 0 and dc > 0   # down right
      if target_coord.row == 3 and target_coord.column - dc == 0
        (?> * dc) + (?v * dr) + 'A'
      else
        (?v * dr) + (?> * dc) + 'A'
      end
    end
  end
end

class DirectionalKeypad
  def initialize keypad
    @buttons = {
      '^' => Coordinate.new(0, 1),
      'A' => Coordinate.new(0, 2),

      '<' => Coordinate.new(1, 0),
      'v' => Coordinate.new(1, 1),
      '>' => Coordinate.new(1, 2),
    }
    @selected_coord = @buttons['A']
    @keypad = keypad
  end

  def move_to(n)
    target = @keypad.move_to(n)
    res = ''
    target.each_char do |a|
      foo = move_to_arrow(a)
      res += foo
    end

    res
  end

  def move_to_arrow(a)
    target_coord = @buttons[a]
    dr = target_coord.row - @selected_coord.row
    dc = target_coord.column - @selected_coord.column
    @selected_coord = target_coord

    if dr <= 0 and dc <= 0    # up left
      (?< * -dc) + (?^ * -dr) + 'A'
    elsif dr <= 0 and dc > 0  # up right
      (?> * dc) + (?^ * -dr) + 'A'
    elsif dr > 0 and dc <= 0  # down left
      (?v * dr) + (?< * -dc) + 'A'
    elsif dr > 0 and dc > 0   # down right
      (?v * dr) + (?> * dc) + 'A'
    end
  end
end

class Star < SuperStar
  def initialize
    super(21, 1)
  end

  def run(input)
    score = 0
    keypad = DirectionalKeypad.new(NumericKeypad.new)
    keypad = DirectionalKeypad.new(keypad)


    input.each_line do |line|
      target_n = line
      length = 0
      line.each_char do |n|
        l = keypad.move_to(n).size
        length += l
      end
      score += length * line.to_i
    end

    score
  end
end

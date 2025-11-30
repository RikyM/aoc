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
    @memo = {}
  end

  def move_to(n)
    key = [n, @selected_coord]
    cached_value = @memo[key]
    unless cached_value.nil?
      @selected_coord = @buttons[n]
      return cached_value
    end

    target_coord = @buttons[n]
    dr = target_coord.row - @selected_coord.row
    dc = target_coord.column - @selected_coord.column
    @selected_coord = target_coord

    res = 0
    if dr <= 0 and dc <= 0    # up left
      if target_coord.row - dr == 3 and target_coord.column == 0
        dr.abs.times{res = res * 6 + 1}
        dc.abs.times{res = res * 6 + 4}
        #res = (?^ * -dr) + (?< * -dc) + 'A'
      else
        dc.abs.times{res = res * 6 + 4}
        dr.abs.times{res = res * 6 + 1}
        #res = (?< * -dc) + (?^ * -dr) + 'A'
      end
    elsif dr <= 0 and dc > 0  # up right
      dr.abs.times{res = res * 6 + 1}
      dc.abs.times{res = res * 6 + 2}
      #res = (?^ * -dr) + (?> * dc) + 'A'
    elsif dr > 0 and dc <= 0  # down left
      dr.abs.times{res = res * 6 + 3}
      dc.abs.times{res = res * 6 + 4}
      #res = (?v * dr) + (?< * -dc) + 'A'
    elsif dr > 0 and dc > 0   # down right
      if target_coord.row == 3 and target_coord.column - dc == 0
        dc.abs.times{res = res * 6 + 2}
        dr.abs.times{res = res * 6 + 3}
        #res = (?> * dc) + (?v * dr) + 'A'
      else
        dr.abs.times{res = res * 6 + 3}
        dc.abs.times{res = res * 6 + 2}
        #res = (?v * dr) + (?> * dc) + 'A'
      end
    end
    return res * 6 + 5
    res = res * 6 + 5

    #@memo[key] = res
    res
    return res
  end
end

class DirectionalKeypad
  def initialize keypad, id
    #@buttons = {
    #  '^' => Coordinate.new(0, 1),
    #  'A' => Coordinate.new(0, 2),

    #  '<' => Coordinate.new(1, 0),
    #  'v' => Coordinate.new(1, 1),
    #  '>' => Coordinate.new(1, 2),
    #}
    @id = id
    @@buttons = [
      nil, # No button
      Coordinate.new(0, 1), # 1: ^
      Coordinate.new(1, 2), # 2: >
      Coordinate.new(1, 1), # 3: v
      Coordinate.new(1, 0), # 4: <
      Coordinate.new(0, 2)  # 5: A
    ]
    @selected_coord = @@buttons[5]
    @keypad = keypad
    @@memo = {}
    @memo_move = {}
  end

  def move_to(n)
    foo = @selected_coord
    target = @keypad.move_to(n)
    key = n.to_i + (@selected_coord.row * 10) + (@selected_coord.column * 100)
    #key = [target, @selected_coord]
    cached_value = @memo_move[key]
    unless cached_value.nil?
      puts 'cached move'
      @selected_coord = cached_value[:selected]
      return cached_value
    end

    case target
    when Integer
      t = target
    else
      t = target[:res]
    end
    #res = ''
    #target.each_char do |a|
    #  foo = move_to_arrow(a)
    #  res += foo
    #end
    res = 0
    until t == 0
      a = t % 6
      partial_res = move_to_arrow_num(a)
      res = (res * (6 ** digits6(partial_res))) + partial_res
      t /= 6
    end

    @memo_move[key] = {
      res: res,
      selected_coord: @selected_coord
    }

    res
  end

  def digits6(num)
    (Math.log(num) / Math.log(6)).floor + 1
  end

  def move_to_arrow(a)
    key = [a, @selected_coord]
    cached_value = @@memo[key]
    unless cached_value.nil?
      puts 'hit'
      @selected_coord = @buttons[a]
      return cached_value
    end

    target_coord = @buttons[a]
    dr = target_coord.row - @selected_coord.row
    dc = target_coord.column - @selected_coord.column
    @selected_coord = target_coord

    if dr <= 0 and dc <= 0    # up left
      res = (?< * -dc) + (?^ * -dr) + 'A'
    elsif dr <= 0 and dc > 0  # up right
      res = (?> * dc) + (?^ * -dr) + 'A'
    elsif dr > 0 and dc <= 0  # down left
      res = (?v * dr) + (?< * -dc) + 'A'
    elsif dr > 0 and dc > 0   # down right
      res = (?v * dr) + (?> * dc) + 'A'
    end

    @@memo[key] = res
    res
  end

  def move_to_arrow_num(a)
    key = a + (@selected_coord.row * 10) + (@selected_coord.column * 100)
    cached_value = @@memo[key]
    unless cached_value.nil?
      @selected_coord = @@buttons[a]
      return cached_value
    end

    target_coord = @@buttons[a]
    dr = target_coord.row - @selected_coord.row
    dc = target_coord.column - @selected_coord.column
    @selected_coord = target_coord

    res = 0
    if dr <= 0 and dc <= 0    # up left
      dc.abs.times{res = res * 6 + 4}
      dr.abs.times{res = res * 6 + 1}
      #res = (?< * -dc) + (?^ * -dr) + 'A'
    elsif dr <= 0 and dc > 0  # up right
      dc.abs.times{res = res * 6 + 2}
      dr.abs.times{res = res * 6 + 1}
      #res = (?> * dc) + (?^ * -dr) + 'A'
    elsif dr > 0 and dc <= 0  # down left
      dr.abs.times{res = res * 6 + 3}
      dc.abs.times{res = res * 6 + 4}
      #res = (?v * dr) + (?< * -dc) + 'A'
    elsif dr > 0 and dc > 0   # down right
      dr.abs.times{res = res * 6 + 3}
      dc.abs.times{res = res * 6 + 2}
      #res = (?v * dr) + (?> * dc) + 'A'
    end

    res = res * 6 + 5

    @@memo[key] = res
    res
  end
end

class Star < SuperStar
  def initialize
    super(21, 2)
  end

  def run(input)
    score = 0
    keypad = NumericKeypad.new
    25.times do |i|
      keypad = DirectionalKeypad.new(keypad, i)
    end

    input.each_line do |line|
      target_n = line
      length = 0
      prev_char = '.'
      line.each_char do |n|
        l = keypad.move_to(n).size
        l = (Math.log(l) / Math.log(6)).floor + 1
        length += l
      end
      score += length * line.to_i
    end

    score
  end
end

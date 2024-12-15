# frozen_string_literal: true

require 'colorize'
require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(15, 1)
  end

  def run(input)
    moves = ''

    @walls = Set.new
    @goods_left = Set.new
    @goods_right = Set.new
    @robot = nil

    row = 0
    input.each_line do |line|
      case line
      when /^[>v<^]+$/
        moves += line
      else
        line.each_char.with_index do |char, c|
          column = c * 2
          case char
          when '#'
            @walls << Coordinate.new(row, column)
            @walls << Coordinate.new(row, column+1)
          when 'O'
            @goods_left << Coordinate.new(row, column)
            @goods_right << Coordinate.new(row, column+1)
          when '@'
            @robot = Coordinate.new(row, column)
          end
        end

        row += 1
      end
    end

    print_map(row)

    moves.each_char.with_index do |move, i|
      direction = translate_direction(move)

      try_to_move_robot direction

      #puts ''
      #puts "Move #{i}(#{move})"

      #print_map(row)
    end

    print_map(row)

    @goods_left.map{|g| g.row * 100 + (g.column / 1)}.sum
  end

  private

  def try_to_move_robot(direction)
    move_robot(direction) if can_move_robot?(direction)
  end

  def can_move_robot? direction
    new_pos = @robot.move(direction)
    return false if @walls.include? new_pos
    return false if @goods_left.include?(new_pos) and not can_move_good_left?(new_pos, direction)
    return false if @goods_right.include?(new_pos) and not can_move_good_right?(new_pos, direction)
    true
  end

  def can_move_good_left?(pos, direction, coming_from_other_half=false)
    new_pos = pos.move(direction)

    return false if @walls.include?(new_pos)

    return false if (not coming_from_other_half) and not can_move_good_right?(pos.move(:right), direction, true)

    return false if @goods_left.include?(new_pos) and not can_move_good_left?(new_pos, direction)
    return false if direction != :right and @goods_right.include?(new_pos) and not can_move_good_right?(new_pos, direction)

    true
  end

  def can_move_good_right?(pos, direction, coming_from_other_half=false)
    new_pos = pos.move(direction)

    return false if @walls.include?(new_pos)

    return false if (not coming_from_other_half) and not can_move_good_left?(pos.move(:left), direction, true)

    return false if @goods_right.include?(new_pos) and not can_move_good_right?(new_pos, direction)
    return false if direction != :left and @goods_left.include?(new_pos) and not can_move_good_left?(new_pos, direction)

    true
  end

  def move_robot direction
    new_pos = @robot.move(direction)

    move_good_left(new_pos, direction)
    move_good_right(new_pos, direction)

    @robot = new_pos
  end

  def move_good_left pos, direction, coming_from_other_half = false
    return unless @goods_left.include? pos
    new_pos = pos.move(direction)

    move_good_right(pos.move(:right), direction, true) unless coming_from_other_half

    move_good_left(new_pos, direction)
    if direction != :right
      move_good_right(new_pos, direction)
    end

    @goods_left.delete pos
    @goods_left << new_pos
  end

  def move_good_right pos, direction, coming_from_other_half = false
    return unless @goods_right.include? pos
    new_pos = pos.move(direction)

    move_good_left(pos.move(:left), direction, true) unless coming_from_other_half

    if direction != :left
      move_good_left(new_pos, direction)
    end
    move_good_right(new_pos, direction)

    @goods_right.delete pos
    @goods_right << new_pos
  end

  #def try_to_move_good_right pos, direction, coming_from_other_half = false
  #  new_pos = pos.move(direction)

  #  return false if @walls.include?(new_pos)

  #  unless coming_from_other_half
  #    return false unless try_to_move_good_left(pos.move(:left), direction, true)
  #  end

  #  if direction != :left and @goods_left.include?(new_pos)
  #    return false unless try_to_move_good_left(new_pos, direction)
  #  end
  #  if @goods_right.include?(new_pos)
  #    return false unless try_to_move_good_right(new_pos, direction)
  #  end

  #  @goods_right.delete pos
  #  @goods_right << new_pos

  #  true
  #end

  def translate_direction move
    case move
    when '^'
      :up
    when '>'
      :right
    when '<'
      :left
    when 'v'
      :down
    end
  end

  def print_map(size)
    size.times do |row|
      (size * 2).times do |column|
        c = Coordinate.new(row, column)

        if @robot == c
          print '@'.colorize(:yellow)
        elsif @goods_left.include?(c)
          print '['.colorize(:light_blue)
        elsif @goods_right.include?(c)
          print ']'.colorize(:light_blue)
        elsif @walls.include?(c)
          print '#'.colorize(:red)
        else
          print '.'.colorize(:light_black)
        end
      end

      puts
    end
  end
end

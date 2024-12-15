# frozen_string_literal: true

require 'colorize'
require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(15, 2)

    @print_map = false
    @dirs = {
      '^' => :up,
      '>' => :right,
      '<' => :left,
      'v' => :down,
    }
  end

  def run(input)
    moves = []

    @walls = Set.new
    @boxes = { left: Set.new, right: Set.new}
    @robot = nil

    row = 0
    input.each_line do |line|
      case line
      when /^[>v<^]+$/
        moves += line.chars.map{|c| @dirs[c]}
      else
        line.each_char.with_index do |char, c|
          column = c * 2
          case char
          when '#'
            @walls << Coordinate.new(row, column)
            @walls << Coordinate.new(row, column+1)
          when 'O'
            @boxes[:left] << Coordinate.new(row, column)
            @boxes[:right] << Coordinate.new(row, column+1)
          when '@'
            @robot = Coordinate.new(row, column)
          else
            # Empty space
          end
        end

        row += 1
      end
    end

    print_map(row-1) if @print_map

    moves.each {|direction| try_to_move_robot direction}

    if @print_map
      puts
      print_map(row-1)
    end

    @boxes[:left].map{|g| g.row * 100 + g.column}.sum
  end

  private

  def try_to_move_robot(direction)
    move_robot(direction) if can_move_robot?(direction)
  end

  def can_move_robot? direction
    new_pos = @robot.move(direction)
    return false if @walls.include? new_pos
    [:left, :right].each do |half|
      return false if @boxes[half].include?(new_pos) and not can_move_box?(new_pos, half, direction)
    end
    true
  end

  def can_move_box?(pos, half, direction, coming_from_other_half=false)
    new_pos = pos.move(direction)
    other_half = half == :left ? :right : :left

    return false if @walls.include?(new_pos)

    return false if (not coming_from_other_half) and not can_move_box?(pos.move(other_half), other_half, direction, true)

    return false if @boxes[half].include?(new_pos) and not can_move_box?(new_pos, half, direction)
    return false if direction != other_half and @boxes[other_half].include?(new_pos) and not can_move_box?(new_pos, other_half, direction)

    true
  end

  def move_robot direction
    new_pos = @robot.move(direction)

    [:left, :right].each {|half| move_box(new_pos, half, direction)}

    @robot = new_pos
  end

  def move_box pos, half, direction, coming_from_other_half = false
    return unless @boxes[half].include? pos
    new_pos = pos.move(direction)
    other_half = half == :left ? :right : :left

    move_box(pos.move(other_half), other_half, direction, true) unless coming_from_other_half

    move_box(new_pos, half, direction)
    move_box(new_pos, other_half, direction) if direction != other_half

    @boxes[half].delete pos
    @boxes[half] << new_pos
  end

  def print_map(size)
    size.times do |row|
      (size * 2).times do |column|
        c = Coordinate.new(row, column)

        if @robot == c
          print '@'.colorize(:yellow)
        elsif @boxes[:left].include?(c)
          print '['.colorize(:light_blue)
        elsif @boxes[:right].include?(c)
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

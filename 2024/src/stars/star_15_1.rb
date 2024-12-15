# frozen_string_literal: true

require 'colorize'
require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  attr_accessor :print_map

  def initialize
    super(15, 1)

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
    @boxes = Set.new
    @robot = nil

    row = 0
    input.each_line do |line|
      case line
      when /^[>v<^]+$/
        moves += line.chars.map{|c| @dirs[c]}
      else
        line.each_char.with_index do |char, column|
          case char
          when '#'
            @walls << Coordinate.new(row, column)
          when 'O'
            @boxes << Coordinate.new(row, column)
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

    @boxes.map{|g| g.row * 100 + g.column}.sum
  end

  private

  def try_to_move_robot direction
    new_pos = @robot.move(direction)

    return false if @walls.include?(new_pos)
    return false if @boxes.include?(new_pos) and not try_to_move_box(new_pos, direction)

    @robot = new_pos
    true
  end

  def try_to_move_box pos, direction
    new_pos = pos.move(direction)

    return false if @walls.include?(new_pos)
    return false if @boxes.include?(new_pos) and not try_to_move_box(new_pos, direction)

    @boxes.delete pos
    @boxes << new_pos
    true
  end

  def print_map(size)
    size.times do |row|
      size.times do |column|
        c = Coordinate.new(row, column)

        if @robot == c
          print '@'.colorize(:yellow)
        elsif @boxes.include?(c)
          print 'O'.colorize(:light_blue)
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
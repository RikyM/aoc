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
    @goods = Set.new
    @robot = nil

    row = 0
    input.each_line do |line|
      case line
      when /^[>v<^]+$/
        moves += line
      else
        line.each_char.with_index do |char, column|
          case char
          when '#'
            @walls << Coordinate.new(row, column)
          when 'O'
            @goods << Coordinate.new(row, column)
          when '@'
            @robot = Coordinate.new(row, column)
          end
        end

        row += 1
      end
    end

    #print_map(row)

    moves.each_char.with_index do |move, i|
      direction = translate_direction(move)

      try_to_move_robot direction

      puts ''
      puts "Move #{i}(#{move})"

      #print_map(row)
    end

    @goods.map{|g| g.row * 100 + g.column}.sum
  end

  private

  def try_to_move_robot direction
    new_pos = @robot.move(direction)

    return false if @walls.include?(new_pos)
    if @goods.include?(new_pos)
      return false unless try_to_move_good(new_pos, direction)
    end

    @robot = new_pos
    true
  end

  def try_to_move_good pos, direction
    new_pos = pos.move(direction)

    return false if @walls.include?(new_pos)
    if @goods.include?(new_pos)
      return false unless try_to_move_good(new_pos, direction)
    end

    @goods.delete pos
    @goods << new_pos

    true
  end

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
      size.times do |column|
        c = Coordinate.new(row, column)

        if @robot == c
          print '@'.colorize(:yellow)
        elsif @goods.include?(c)
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
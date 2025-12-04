# frozen_string_literal: true

require_relative '../super_star'

require 'set'
require 'colorize'

class Star < SuperStar
  def initialize
    super('4', '1')
  end

  def run(input)
    rolls = Set.new

    row = 0
    input.each_line do |line|
      line.each_char.with_index do |char, column|
        if char == ?@
          rolls.add(Star.coord_of(row, column))
        end
      end
      row += 1
    end

    rolls.map { |roll_coord| Star.neighbours(roll_coord)
                                .select{|n| rolls.include? n}
                                .size }
      .filter{|ns| ns < 4}
      .size
  end

  def self.coord_of row, column
    return row * 1000 + column
  end

  def self.neighbours coord
    return [
      coord - 1001, coord - 1000, coord - 999,
      coord - 1,                  coord + 1,
      coord + 999,  coord + 1000, coord + 1001]
  end

  def print_grid(rolls, dim)
    (0...dim).each do |r|
      (0...dim).each do |c|
        if rolls.include? Star.coord_of(r, c)
          n_neighs = Star.neighbours(Star.coord_of(r, c)).select{|n| rolls.include? n}.size
          if n_neighs < 4
            print '@'.colorize(:red)
          else
            print ?@
          end
        else
          print ?.
        end
      end
      puts
    end
  end
end
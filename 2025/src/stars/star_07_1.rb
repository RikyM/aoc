# frozen_string_literal: true

require_relative '../super_star'

require 'set'

class Coord
  attr_accessor :x, :y

  def initialize row, column
    @x = column
    @y = row
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def eql?(other)
    self == other
  end

  def hash
    [@x, @y].hash
  end
end

class Star < SuperStar
  def initialize
    super('7', '1')
  end

  def run(input)
    row = 0
    to_visit = []
    splitters = {}
    input.each_line do |line|
      line.each_char.with_index do |c, column|
        case c
        when ?S
          to_visit << Coord.new(row, column)  # Skipping first splitter actually works
        when ?^
          splitters[column] = {} unless splitters.include? column
          splitters[column][row] = {} unless splitters[column].include? row

          splitters[column][row] = Coord.new(row, column)
        else
          # Empty space
        end
      end
      row += 1
    end

    visited = Set.new
    split_count = 0
    until to_visit.empty?
      visiting = to_visit.shift
      next if visited.include? visiting
      visited << visiting
      split_count += 1

      lb = first_below(splitters, visiting.x-1, visiting.y)
      to_visit << lb unless lb.nil?

      rb = first_below(splitters, visiting.x+1, visiting.y)
      to_visit << rb unless rb.nil?
    end

    split_count
  end

  private
  def first_below(splitters, x, y)
    splitters_in_column = splitters[x]
    return nil if splitters_in_column.nil?

    found_y = splitters_in_column.keys.filter{|sy| sy > y}.min
    splitters[x][found_y]
  end
end
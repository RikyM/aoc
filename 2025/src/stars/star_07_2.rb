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

  def inspect
    to_s
  end

  def to_s
    "[#{y}, #{x}]"
  end
end

class Star < SuperStar
  def initialize
    super('7', '2')
  end

  def run(input)
    row = 0
    start = nil

    splitters_cr = {}
    splitters_r = {}
    input.each_line do |line|
      line.each_char.with_index do |c, column|
        case c
        when ?S
          start = Coord.new(row, column)
        when ?^
          splitters_cr[column] = {} unless splitters_cr.include? column
          splitters_cr[column][row] = {} unless splitters_cr[column].include? row
          splitters_cr[column][row] = Coord.new(row, column)

          splitters_r[row] = [] unless splitters_r.include? row
          splitters_r[row] << Coord.new(row, column)
        else
          # Empty space
        end
      end
      row += 1
    end

    timelines_starting_from = {}

    splitters_r.sort_by{|a| -a[0]}.each do |_, splitters_in_row|
      splitters_in_row.each do |visiting|
        count = 0

        lb = first_below(splitters_cr, visiting.x-1, visiting.y)
        count += lb.nil? ? 1 : timelines_starting_from[lb]

        rb = first_below(splitters_cr, visiting.x+1, visiting.y)
        count += rb.nil? ? 1 : timelines_starting_from[rb]

        timelines_starting_from[visiting] = count
      end
    end

    first_splitter = splitters_cr[start.x].min_by{|c| c[0]}[1]
    timelines_starting_from[first_splitter]
  end

  private
  def first_below(splitters, x, y)
    splitters_in_column = splitters[x]
    return nil if splitters_in_column.nil?

    found_y = splitters_in_column.keys.filter{|sy| sy > y}.min
    splitters[x][found_y]
  end
end
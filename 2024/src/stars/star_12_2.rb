# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Edge
  attr_reader :orientation

  def initialize ul_corner, orientation
    @ul_corner = ul_corner
    @orientation = orientation
  end

  def row
    @ul_corner.row
  end

  def column
    @ul_corner.column
  end

  def self.of_coord_going coord, direction
    case direction
    when :up
      return new coord, :horizontal
    when :right
      return new coord.move(:right), :vertical
    when :down
      return new coord.move(:down), :horizontal
    when :left
      return new coord, :vertical
    else
      raise "Unknown direction #{direction}"
    end
  end

  def neighs
    if @orientation == :vertical
      [
        Edge.new(@ul_corner.move(:up), :vertical),
        Edge.new(@ul_corner.move(:down), :vertical)]
    else
      [
        Edge.new(@ul_corner.move(:left), :horizontal),
        Edge.new(@ul_corner.move(:right), :horizontal)]
    end
  end

  def movable_directions
    if @orientation == :vertical
      [:up, :down]
    else
      [:left, :right]
    end
  end

  def move direction
    Edge.new(@ul_corner.move(direction), orientation)
  end

  def ==(other)
    @ul_corner == other and @orientation == other.orientation
  end

  def eql?(other)
    self == other
  end

  def hash
    [@ul_corner, @orientation].hash
  end
end

class Star < SuperStar
  def initialize
    super(12, 2)
  end

  def run(input)
    plants = Hash.new { |hash, key| hash[key] = Set.new }

    #garden = Grid.new
    row = 0
    input.each_line do |line|
      line.chars.each.with_index do |plant, column|
        plants[plant] << Coordinate.new(row, column)
      end
      row += 1
      #garden << line
    end

    res = 0
    plants.each_pair do |plant, coords|
      until coords.empty?
        coords.first
        score = score_group_of(coords.first, coords, plant)
        res += score
      end
    end

    res
  end

  def score_group_of(coord, coords, plant)
    to_see = [coord]
    seen = Set.new

    edges = Set.new

    until to_see.empty?
      c = to_see.pop
      next if seen.include?(c)

      c.oriented_neighs.each_pair do |direction, n|
        next if seen.include?(n)
        if coords.include?(n)
          to_see << n
        else
          edges << Edge.of_coord_going(c, direction)
        end
      end

      seen << c
    end

    sides = count_sides(edges)

    coords.subtract(seen)
    sides * seen.size
  end

  def count_sides(edges)
    seen = Set.new

    res = 0
    edges.each do |e|
      next if seen.include?(e)

      e.movable_directions.each do |direction|
        n = e.move(direction)
        while edges.include?(n)
          seen << n
          n = n.move(direction)
        end
      end

      seen << e
      res += 1
    end

    res
  end
end

puts Star.new.help_the_elves

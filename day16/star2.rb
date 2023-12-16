#!/usr/bin/env ruby

require 'colorize'
require 'set'

input_file = ARGV[0]

input = File.read(input_file)

class Floor
  attr_reader :energized, :edges_hit, :max_x, :max_y

  def initialize grid
    @grid = grid

    @max_y = grid.size - 1
    @max_x = grid[0].size - 1

    @energized = []
    @seen_beams = Set.new
    @edges_hit = []
  end

  def interact beam
    return [] if @seen_beams.include? beam

    @seen_beams.add beam

    x = beam.x
    y = beam.y
    dir = beam.dir

    if y < 0 or y > @max_y or x < 0 or x > @max_x
      @edges_hit << Beam.new(x, y, inverse(dir))
      return []
    end

    @energized << {x: x, y: y}

    tile = @grid[y][x]

    case tile
    when '.'
      return [beam]
    when '-'
      return [beam] if [:right, :left].include?(dir)
      return [Beam.new(x, y, :left), Beam.new(x, y, :right)]
    when '|'
      return [beam] if [:up, :down].include?(dir)
      return [Beam.new(x, y, :up), Beam.new(x, y, :down)]
    when '/'
      return [Beam.new(x, y, :left )] if dir == :down
      return [Beam.new(x, y, :down )] if dir == :left
      return [Beam.new(x, y, :right)] if dir == :up
      return [Beam.new(x, y, :up   )] if dir == :right
    when '\\'
      return [Beam.new(x, y, :right)] if dir == :down
      return [Beam.new(x, y, :up   )] if dir == :left
      return [Beam.new(x, y, :left )] if dir == :up
      return [Beam.new(x, y, :down )] if dir == :right
    end

    raise 'Something went wrong'
  end

  def print
    @grid.each.with_index do |row, y|
      row.each_char.with_index do |c, x|
        if @energized.include?({x: x, y: y})
          STDERR.print c.yellow
        else
          STDERR.print c
        end
      end

      STDERR.puts
    end
  end

  def reset
    @energized = []
    @seen_beams = Set.new
  end

  private

  def inverse dir
    return :up    if dir == :down
    return :right if dir == :left
    return :down  if dir == :up
    return :left  if dir == :right
  end
end

class Beam
  attr_reader :x, :y, :dir

  def initialize x, y, dir
    @x = x
    @y = y
    @dir = dir
  end

  def move
    case @dir
    when :right
      Beam.new @x+1, @y, @dir
    when :left
      Beam.new @x-1, @y, @dir
    when :up
      Beam.new @x, @y-1, @dir
    when :down
      Beam.new @x, @y+1, @dir
    end
  end

  def == other
    @x == other.x and @y == other.y and @dir == other.dir
  end

  def eql? other
    self == other
  end

  def hash
    [@x,@y,@dir].hash
  end
end

def log message
  STDERR.puts message
end

floor = Floor.new input.lines.map(&:chomp)

starting_beams = []
(0..floor.max_x).each do |x|
  starting_beams << Beam.new(x, -1, :down)
  starting_beams << Beam.new(x, floor.max_y+1, :up)
end
(0..floor.max_y).each do |y|
  starting_beams << Beam.new(-1, y, :right)
  starting_beams << Beam.new(floor.max_x+1, y, :left)
end

max_energy = -1
until starting_beams.empty?
  floor.reset

  beams = [starting_beams.pop]

  until beams.empty?
    beam = beams.pop.move
    new_beams = floor.interact(beam)
    new_beams.each {|b| beams << b}
  end
  
  max_energy = [max_energy, floor.energized.uniq.size].max
  
  starting_beams -= floor.edges_hit
end

puts max_energy

#!/usr/bin/env ruby


require 'colorize'
require 'set'

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Dir
  @@opposites = {U: :D, D: :U, L: :R, R: :L}

  def self.opposite dir
    @@opposites[dir]
  end

  def Dir.new_inner old_dir, new_dir, old_inner
    case new_dir
    when :R
      if old_dir == :U
        old_inner == :R ? :D : :U
      else # old_dir == :D
        old_inner == :R ? :U : :D
      end
    when :L
      if old_dir == :U
        old_inner == :L ? :D : :U
      else # old_dir == :D
        old_inner == :L ? :U : :D
      end
    when :U
      if old_dir == :R
        old_inner == :U ? :L : :R
      else # old_dir == :L
        old_inner == :U ? :R : :L
      end
    when :D
      if old_dir == :R
        old_inner == :D ? :L : :R
      else # old_dir == :L
        old_inner == :D ? :R : :L
      end
    end
  end
end

class Coord
  attr_reader :x, :y

  def initialize x, y
    @x = x
    @y = y
  end

  def == other
    @x == other.x and @y == other.y
  end

  def eql? other
    self == other
  end

  def hash
    [@x, @y].hash
  end

  def neigh dir
    case dir
    when :R
      Coord.new @x+1, @y
    when :L
      Coord.new @x-1, @y
    when :D
      Coord.new @x, @y+1
    when :U
      Coord.new @x, @y-1
    end
  end

  def neighs
    [ Coord.new(@x+1, @y),
      Coord.new(@x-1, @y),
      Coord.new(@x, @y+1),
      Coord.new(@x, @y-1)]
  end

  def to_s
    "{x: #@x; y: #@y}"
  end
end

def print border, filling
  min_x = border.map(&:x).min-1
  max_x = border.map(&:x).max+1
  min_y = border.map(&:y).min-1
  max_y = border.map(&:y).max+1

  min_y.upto(max_y) do |y|
    min_x.upto(max_x) do |x|
      coord = Coord.new(x, y)

      if border.include? coord
        if $debug_coord == coord
          STDERR.print "#".black.on_green
        else
          STDERR.print "#".black.on_yellow
        end
      elsif filling.include? coord
        if coord == $debug_coord
          STDERR.print ".".black.on_green
        else
          STDERR.print ".".red
        end
      else
        STDERR.print "."
      end
    end
    STDERR.puts
  end
end

$debug_coord = Coord.new 1, 0

current = Coord.new 0, 0
border = nil
inner  = nil
[:U, :D, :L, :R].each do |current_inner|
  inner   = {current => current_inner}

  border = Set.new
  border.add current

  old_dir = input.lines[-1][0].to_sym

  input.each_line do |l|
    dir, count, _ = l.split
    new_dir = dir.to_sym
    count = count.to_i

    prev_inner = current_inner
    current_inner = Dir.new_inner old_dir, new_dir, current_inner

    count.times do |i|
      current = current.neigh new_dir
      border.add current
      inner[current] = current_inner
    end

    old_dir = new_dir
  end

  min_y = border.map(&:y).min
  unless border.filter{|b|b.y == min_y}.any?{|b|inner[b] == :U}
    break
  end
end

filling = Set.new

to_see = Set.new

border.each do |b|
  current = b
  dir = inner[b]

  to_see.add b.neigh(dir) unless border.include?(b.neigh dir)
end

until to_see.empty?
  current = to_see.first
  to_see.delete current
  filling.add current

  current.neighs.each do |n|
    to_see.add(n) unless (border.include?(n) or filling.include?(n))
  end
end

puts border.size + filling.size

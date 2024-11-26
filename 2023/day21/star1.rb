#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

require 'set'

STEPS = 6
#STEPS = 64

def log message
  STDERR.puts message
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

  def neighs 
    [
      Coord.new(@x+1, @y),
      Coord.new(@x-1, @y),
      Coord.new(@x, @y+1),
      Coord.new(@x, @y-1)
    ]
  end

  def to_s
    "[#@x, #@y]"
  end
end

rocks = Set.new
start = nil

input.each_line.with_index do |row, y|
  row.each_char.with_index do |c,x|
    case c
    when ?#
      rocks.add Coord.new(x, y)
    when ?S
      start = Coord.new(x, y)
    end
  end
end

to_visit = [start]
distances = {start => 0}

STEPS.times do |i|
  new_to_visit = []

  to_visit.each do |patch|
    neighs = patch.neighs.filter{|p| not(rocks.include? p) and not(distances.include? p)}
    neighs.each do |n|
      new_to_visit << n
      distances[n] = i+1
    end
  end

  to_visit = new_to_visit
end

puts distances.count{|c, d| d.even?}

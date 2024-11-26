#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Galaxy
  attr_reader :x, :y

  def initialize x, y
    @x = x
    @y = y
  end

  def expand! missing_xs, missing_ys
    new_x = x
    new_y = y

    missing_xs.each {|x| new_x += 1 if @x > x}
    missing_ys.each {|y| new_y += 1 if @y > y}

    @x = new_x
    @y = new_y
  end

  def distance other
    (@x - other.x).abs + (@y - other.y).abs
  end
end

def find_missing_xs galaxies
  xs = galaxies.map(&:x)
  (0..(xs.max)).filter{|x| not xs.include? x}
end

galaxies = []
missing_xs = []
missing_ys = []

input.each_line.with_index do |row, y|
  found_galaxy_in_row = false

  row.each_char.with_index do |c, x|
    if c == ?#
      galaxies << Galaxy.new(x, y)
      found_galaxy_in_row = true
    end
  end

  missing_ys << y unless found_galaxy_in_row
end

missing_xs = find_missing_xs galaxies

galaxies.each{|g| g.expand! missing_xs, missing_ys}

puts galaxies.combination(2).map {|a, b| a.distance(b)}.sum

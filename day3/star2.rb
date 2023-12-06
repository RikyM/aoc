#!/usr/bin/env ruby

class Coord
  def initialize x, y, tree=$coords
    @x  = x
    @y  = y
    @ns = nil
    @tree = tree
  end

  def << n
    @ns = n
  end

  def at? x, y
    return (@x == x and @y == y)
  end

  def adj
    res = []
    res << @tree.get(@x-1, @y)
    res << @tree.get(@x+1, @y)
    (@x-1..@x+1).each do |x|
      res << @tree.get(x, @y-1)
      res << @tree.get(x, @y+1)
    end
    res.filter{|x| not x.nil?}
  end

  def numbers
    @ns
  end

  def inspect
    "[#@x, #@y]"
  end
end

class CoordTree
  def initialize
    @coords = []
  end

  def add x, y
    c = get x, y
    return c unless c.nil?

    c = Coord.new x, y
    @coords << c
    return c
  end

  def get x, y
    return @coords.filter{|c| c.at? x, y}.first
  end
end

$coordinates = []
$stars = []

def log message
  STDERR.puts message
end

$coords = CoordTree.new
$stars = []

def add_symbol y, x
  $symbols << [y, x]
end

def is_symbol? y, x
  $symbols.include? [y, x]
end

class Number
  attr_reader :n, :i

  def initialize n, i=n
    @n = n
    @i = i
  end
  
  def == other
    case other
    when Number
      @i == other.i
    when Integer
      @n == other
    else
      false
    end
  end

  def to_i
    @n
  end

  def inspect
    "n(#{@n})"
  end
end

def extract_numbers(line, y)
  ni = 0
  parsing_number = ''

  line.each_char.with_index do |c, i|
    case c
    when /[0-9]/
      parsing_number += c
    else
      unless parsing_number.empty?
        number = Number.new(parsing_number.to_i, ni)
        ni += 1

        (i-parsing_number.size .. i-1).each do |x|
          $coords.add(x, y) << number
        end
        
        parsing_number = ''
      end

      $stars << Coord.new(i, y) if c == '*'
    end
  end
end

input_file = ARGV[0]

input = File.read(input_file)

input.lines.each.with_index {|l,y| extract_numbers(l,y)}

puts $stars.map{|x| x.adj.map{|a| a.numbers}.uniq}
          .filter{|x| x.size == 2}
          .map{|x| x.map(&:to_i).reduce(&:*)}
          .sum

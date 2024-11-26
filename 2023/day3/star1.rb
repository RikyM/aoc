#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

$numbers = []
$symbols = []

def log message
  STDERR.puts message
end

class Number
  def initialize n, y, x0, x1
    @n  = n
    @y  = y
    @x0 = x0
    @x1 = x1
  end

  def is_next_to_symbol?
    (@x0-1..@x1+1).each do |x|
      return true if (is_symbol? @y-1, x or is_symbol? @y+1, x)
    end

    return (is_symbol?(@y, @x0-1) or is_symbol?(@y, @x1+1))
  end

  def to_i
    @n
  end
end

def add_symbol y, x
  $symbols << [y, x]
end

def is_symbol? y, x
  $symbols.include? [y, x]
end

def extract_numbers(line, y)
  parsing_number = ''

  line.each_char.with_index do |c, i|
    case c
    when /[0-9]/
      parsing_number += c
    else
      unless parsing_number.empty?
        number = Number.new(parsing_number.to_i, y, i-parsing_number.size, i-1)
        $numbers << number
        parsing_number = ''
      end

      add_symbol(y, i) unless (c =~ /[.|\n]/)
    end
  end
end

input.lines.each.with_index {|l,y| extract_numbers(l,y)}

puts $numbers.filter(&:is_next_to_symbol?).map(&:to_i).sum

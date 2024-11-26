#!/usr/bin/env ruby

require 'colorize'

N_CYCLES = 1000000000

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Dish

  def initialize input
    @mirror = input.lines.map(&:chomp)
    @x_size = @mirror.first.size
    @y_size = @mirror.size
  end

  def hash
    @mirror.hash
  end

  def print
    @mirror.each do |row|
      row.each_char do |r|
        case r
        when 'O'
          STDERR.print r.cyan
        when '#'
          STDERR.print r.yellow
        else
          STDERR.print '.'.light_black
        end
      end
      STDERR.puts
    end
  end

  def load
    @mirror.map.with_index {|row,i| row.count(?O) * (@y_size-i)}.sum
  end

  def cycle
    tilt_north
    tilt_west
    tilt_south
    tilt_east
  end

  private

  def tilt_north
    (0...@x_size).each do |x|
      first_free = 0
      (0...@y_size).each do |y|
        case @mirror[y][x]
        when 'O'
          @mirror[first_free][x] = 'O'
          @mirror[y][x] = '.' if first_free != y
          first_free += 1
        when '#'
          first_free = y+1
        end
      end
    end
  end
  
  def tilt_south
    (0...@x_size).each do |x|
      first_free = @y_size-1
      (@y_size-1).downto(0).each do |y|
        case @mirror[y][x]
        when 'O'
          @mirror[first_free][x] = 'O'
          @mirror[y][x] = '.' if first_free != y
          first_free -= 1
        when '#'
          first_free = y-1
        end
      end
    end
  end

  def tilt_east
    (0...@y_size).each do |y|
      first_free = @x_size-1
      (@x_size-1).downto(0).each do |x|
        case @mirror[y][x]
        when 'O'
          @mirror[y][first_free] = 'O'
          @mirror[y][x] = '.' if first_free != x
          first_free -= 1
        when '#'
          first_free = x-1
        end
      end
    end
  end

  def tilt_west
    (0...@y_size).each do |y|
      first_free = 0
      (0...@x_size).each do |x|
        case @mirror[y][x]
        when 'O'
          @mirror[y][first_free] = 'O'
          @mirror[y][x] = '.' if first_free != x
          first_free += 1
        when '#'
          first_free = x+1
        end
      end
    end
  end
end

dish = Dish.new input

loads = []
seen_count = {}
seen_count.default = 0

cycle_start = nil
cycle_size  = nil

N_CYCLES.times{ |i|
  dish.cycle

  loads << dish.load

  hash = dish.hash
  count = seen_count[hash]

  if count == 1 and cycle_start.nil?
    cycle_start = i
  end

  if count == 2
    cycle_size = i - cycle_start
    break
  end

  seen_count[hash] = count + 1
}

equivalent_i = cycle_size.nil? ? N_CYCLES-1 : (N_CYCLES-1 - cycle_start) % cycle_size + cycle_start

puts loads[equivalent_i]

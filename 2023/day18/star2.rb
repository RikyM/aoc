#!/usr/bin/env ruby

require 'set'

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Dir
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

  def neigh dir, count=1
    case dir
    when :R
      Coord.new @x+count, @y
    when :L
      Coord.new @x-count, @y
    when :D
      Coord.new @x, @y+count
    when :U
      Coord.new @x, @y-count
    end
  end
end

class Segment
  attr_reader :inner

  def initialize from, to, direction, inner
    @from = from
    @to = to
    @dir = (direction == :R or direction == :L) ? :hor : :ver
    @inner = inner
  end

  def length
    (@from.x - @to.x).abs + 1
  end
  
  def min_y
    [@from.y, @to.y].min
  end

  def max_y
    [@from.y, @to.y].max
  end

  def ys
    [@from.y, @to.y]
  end

  def xs
    [@from.x, @to.x]
  end

  def at_y? y
    y_min, y_max = [@from.y, @to.y].sort
    y_min <= y and y <= y_max
  end

  def down_from? y
    @dir == :ver and min_y <= y and max_y > y
  end

  def lying_on? y, inner
    @to.y == y and y == @from.y and @inner == inner
  end

  def x_in
    if @dir == :hor
      return @inner == :D ? @from.x : @to.x
    end

    if @dir == :ver
      return @from.x if @inner == :R
    end

    return nil
  end

  def x_out
    if @dir == :hor
      return @inner == :U ? @from.x : @to.x
    end

    if @dir == :ver
      return @from.x if @inner == :L
    end

    return nil
  end
end

$color_direction = [:R, :D, :L, :U]
def decode_color color
  {count: color[2..6].to_i(16), dir: $color_direction[color[-2].to_i]}
end

current = Coord.new 0, 0
current_inner = :R

borders = nil
inner  = nil
[:U, :D, :L, :R].each do |current_inner|
  old_dir = decode_color(input.lines[-1].chomp)[:dir]
  current = Coord.new 0, 0

  borders = Set.new
  input.each_line.with_index do |l|
    decoding = decode_color l.chomp.split.last
    new_dir = decoding[:dir]
    count   = decoding[:count]

    current_inner = Dir.new_inner old_dir, new_dir, current_inner
    next_pos = current.neigh new_dir, count

    borders.add Segment.new(current, next_pos, new_dir, current_inner)
    
    current = next_pos
    old_dir = new_dir
  end

  min_y = borders.map(&:min_y).min
  unless borders.filter{|b|b.min_y == min_y}.any?{|b|b.inner == :U}
    break
  end
end

ys = borders.map(&:ys).flatten.uniq.sort

res = 0
ys.each.with_index do |y,i|
  next_y = ys[i+1]
  if next_y.nil?
    res += borders.filter{|b|b.lying_on? y, :U}.map{|b| b.length}.sum
    break
  end

  bs = borders.filter{|b| b.down_from? y}

  xs_in  = bs.map(&:x_in ).filter{|x| not x.nil?}.sort.uniq
  xs_out = bs.map(&:x_out).filter{|x| not x.nil?}.sort.uniq

  res += xs_in.zip(xs_out).map{|xs| xs[1]-xs[0]+1}.sum * (next_y - y)
  res += borders.filter{|b|b.lying_on? y, :U}.map{ |b| b.length - (bs.filter{|s| b.xs.any?{|x0| s.xs.include? x0}}.count)}.sum
end

puts res

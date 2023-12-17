#!/usr/bin/env ruby

require 'set'

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Coord
  attr_reader :x, :y

  def initialize x, y
    @x = x
    @y = y
  end

  def neighs
    res = {}
    res[:left ] = Coord.new(@x-1, @y  ) if @x > 0
    res[:right] = Coord.new(@x+1, @y  ) if @x < $max_x
    res[:down ] = Coord.new(@x  , @y+1) if @y < $max_y
    res[:up   ] = Coord.new(@x  , @y-1) if @y > 0
    res
  end

  def == other
    @x == other.x and @y == other.y
  end

  def eql? other
    self == other
  end

  def hash
    [x,y].hash
  end

  def <=> other
    res = @y <=> other.y
    return res unless res == 0
    return @x <=> other.x
  end
end

class Position
  attr_reader :coord, :dir, :count

  def initialize coord, dir, count
    @coord = coord
    @dir   = dir
    @count = count

    @@opposite_dir = {up: :down, down: :up, left: :right, right: :left}

    @@dir_n = {up: 0, right: 1, left: 2, down: 3}
  end

  def next
    neighs = @coord.neighs
    neighs.delete @@opposite_dir[@dir]
    if @count == 3
      neighs.delete @dir
    end

   res = []
    neighs.each do |dir, coord|
      res << Position.new(coord, dir, @dir == dir ? @count + 1 : 1)
    end

    res
  end

  def inspect
    "[At #{@coord}, going #{@dir} for #{@count}]"
  end

  def to_s
    inspect
  end

  def == other
    @dir == other.dir and @count == other.count and @coord == other.coord
  end

  def eql? other
    self == other
  end

  def hash
    [@coord, @dir, @count].hash
  end
end

class SeenPositions
  def initialize
    @seen = {}
  end

  def [] pos
    @seen[pos.coord][pos]
  end

  def see pos, loss
    prev_losses = @seen[pos.coord]
    if prev_losses.nil?
      @seen[pos.coord] = {pos => loss}
      return true
    end

    prev_loss = prev_losses.filter{|k,v| k.dir == pos.dir and k.count <= pos.count}.map{|k,v| v}.min
    if prev_loss.nil? or prev_loss > loss
      foo = @seen[pos.coord].filter{|k,v| k.dir == pos.dir and k.count > pos.count and v >= loss}.map{|k,v|k}
      foo.each{|p| $to_see.delete p}
      @seen[pos.coord][pos] = loss
      @seen[pos.coord].filter!{|k,v| not (k.dir == pos.dir and k.count > pos.count and v >= loss)}
      return true
    end
  
    return false
  end
end


city = input.lines.map{|row| row.chomp.chars.map(&:to_i)}

$max_y = city.size - 1
$max_x = city.first.size - 1

start = Coord.new($max_x, $max_y)
target  = Coord.new(0,0)

seen = SeenPositions.new
pos = Position.new start, nil, 1

seen.see pos, city[$max_y][$max_x]

$to_see = Set.new
$to_see.add pos

until $to_see.empty?
  p = $to_see.first
  loss = seen[p]
  $to_see.each do |e|
    e_loss = seen[e]

    if e_loss < loss
      p = e
      loss = e_loss
    end
  end
  $to_see.delete p

  loss = seen[p]
  next if loss.nil?

  if p.coord == target
    puts (loss - city[0][0])
    break
  end

  p.next.each do |np|
    new_loss = loss + city[np.coord.y][np.coord.x]

    if seen.see(np, new_loss)
      $to_see.add(np)
    end
  end
end

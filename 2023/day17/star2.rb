#!/usr/bin/env ruby

require 'colorize'
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

  def to_s
    "{x: #{x}; y: #{y}}"
  end

  def inspect
    to_s
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
  end

  def next
    neighs = @coord.neighs
    neighs.delete @@opposite_dir[@dir]

    if @count < 4 and (not @dir.nil?)
      neighs.filter!{|k,v| k == @dir}
    end
    
    if @count >= 10
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

class Node
  attr_reader :position, :loss, :right
  attr_accessor :left, :parent

  def initialize position, loss
    @position = position
    @loss = loss

    @left = nil
    @right = nil

    @@dir_n = {up: 0, right: 1, down: 3, left: 4}
  end

  def <=> other
    res = loss <=> other.loss
    return res unless res == 0

    coord = @position.coord
    other_coord = other.position.coord
    res = coord.x <=> other_coord.x
    return res unless res == 0

    res = coord.y <=> other_coord.y
    return res unless res == 0
    
    res = @position.count <=> other.position.count
    return res unless res == 0

    return @@dir_n[@position.dir] <=> @@dir_n[other.position.dir]
  end

  def << node
    diff = node <=> self
    return if diff == 0

    if diff < 0
      if @left.nil?
        @left = node
        node.parent = self
        return
      end
      @left << node
    else
      if @right.nil?
        @right = node
        node.parent = self
        return
      end
      @right << node
    end

  end

  def next
    unless @left.nil?
      if @left.last?
        res = @left
        @left = nil
        return res
      else
        return @left.next
      end
    end

    @parent.left = @right
    @right.parent = @parent unless @right.nil?
    return self
  end

  def last?
    @left.nil? and @right.nil?
  end

  def size
    res = 1
    res += @left.size unless @left.nil?
    res += @right.size unless @right.nil?
    res
  end

  def to_s
    coord = @position.coord
    "{x: #{coord.x}; y: #{coord.y}} -> #{@position.dir}(#{@position.count}) [#{@loss}]"
  end
end

class ToSee
  attr_reader :node
  def initialize
    @node = nil
  end

  def left=(node)
    @node = node
  end

  def add pos, loss
    new_node = Node.new pos, loss
    if @node.nil?
      @node = new_node
      new_node.parent = self
    else
      @node << new_node
    end
  end

  def next
    return nil if @node.nil?
    if @node.last?
      res = @node
      @node = nil
      return res
    end
    return @node.next
  end

  def empty?
    return @node.nil?
  end

  def size
    return 0 if @node.nil?
    return @node.size
  end
end


city = input.lines.map{|row| row.chomp.chars.map(&:to_i)}

$max_y = city.size - 1
$max_x = city.first.size - 1

start  = Coord.new(0,0)
target = Coord.new($max_x, $max_y)


seen = Set.new

to_see = ToSee.new
to_see.add Position.new(start, nil, 1), 0

coming_from = {}

until to_see.empty?
  node = to_see.next
  p = node.position
  loss = node.loss

  if p.coord == target
    passed_coords = [p.coord]
    # Print path
    #
    # until p.coord == start
    #   p = coming_from[p]
    #   passed_coords << p.coord
    # end
    #
    # (0..$max_y).each do |y|
    #   (0..$max_x).each do |x|
    #     if passed_coords.any? {|c| c.x == x and c.y == y}
    #       STDERR.print city[y][x].to_s.yellow
    #     else
    #       STDERR.print city[y][x]
    #     end
    #   end
    #   STDERR.puts
    # end

    puts loss
    break
  end

  next_pos = p.next

  next_pos.filter{|np| not seen.include? np}
          .each do |np|
            new_loss = loss + city[np.coord.y][np.coord.x]
            seen.add np
            to_see.add(np, new_loss)
            coming_from[np] = p
          end
end

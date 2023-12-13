#!/usr/bin/env ruby

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Pattern
  attr_reader :rocks
  def initialize
    @rocks = []
    @max_y = 0
    @max_x = 0
  end

  def << rock
    @max_y = [@max_y, rock.y].max
    @max_x = [@max_x, rock.x].max
    @rocks << rock
  end

  def score
    score = fold_horizontal
    return score unless score == 0
    return fold_vertical * 100
  end

  def fold_vertical
    axis = 1

    until axis > @max_y
      min_y = @max_y - (2 * (@max_y - axis)) - 1
      folded = @rocks.map{|x|x.reflect_v(axis)}.filter{|r| not r.nil? and r.y >= min_y}

      if folded.group_by{|r| [r.y, r.x]}.map{|k,v| v.size}.all? {|s| s == 2}
        return axis
      end

      axis += 1
    end

    return 0
  end

  def fold_horizontal
    axis = 1

    until axis > @max_x
      min_x = @max_x - (2 * (@max_x - axis)) - 1
      folded = @rocks.map{|x|x.reflect_h(axis)}.filter{|r| not r.nil? and r.x >= min_x}

      if folded.group_by{|r| [r.y, r.x]}.map{|k,v| v.size}.all? {|s| s == 2}
        return axis
      end

      axis += 1
    end

    return 0
  end

  def print
    (0..@max_y).each do |y|
      (0..@max_x).each do |x|
        if @rocks.include? Rock.new(x, y)
          STDERR.print ?#
        else
          STDERR.print ?.
        end
      end
      STDERR.puts
    end
  end
end

class Rock
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

  def to_s
    "{x: #@x; y: #@y}"
  end

  def reflect_h x_axis
    if @x >= x_axis
      new_x = @x - (2 * (@x - x_axis)) - 1
    else
      new_x = @x
    end

    new_x >= 0 ? Rock.new(new_x, @y) : nil
  end

  def reflect_v y_axis
    if @y >= y_axis
      new_y = @y - (2 * (@y - y_axis)) - 1
    else
      new_y = @y
    end

    new_y >= 0 ? Rock.new(@x, new_y) : nil
  end
end

y = 0
p = Pattern.new
patterns = [p]


(input.lines + ['']).each.with_index do |row|
  row.chomp!

  case row
  when /^$/
    p = Pattern.new
    patterns << p
    y = 0
  else
    row.each_char.with_index do |c, x|
      p << Rock.new(x, y) if c == ?#
    end
    y += 1
  end
end

values = patterns.map{|p| p.score}

puts values.sum

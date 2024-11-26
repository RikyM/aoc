#!/usr/bin/env ruby

require 'colorize'

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
    res = []
    res << {coord: Coord.new(x, y-1), coming_from: :s} if y > 0
    res << {coord: Coord.new(x, y+1), coming_from: :n}
    res << {coord: Coord.new(x-1, y), coming_from: :e} if x > 0
    res << {coord: Coord.new(x+1, y), coming_from: :w}
    return res
  end

  def to_s
    "[#{y},#{x}]"
  end

  def inspect
    to_s
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
end

class Map
  attr_reader :steps
  attr_reader :borders

  @@OPENINGS = {
    '|' => [:n, :s],
    '-' => [:e, :w],
    'L' => [:n, :e],
    'J' => [:n, :w],
    '7' => [:s, :w],
    'F' => [:s, :e],
    'S' => [:n, :s, :w, :e],
    '.' => [],
    nil => []
  }

  def initialize grid
    @grid = grid
    @current_coord = find_start(grid)
    @current_pipe  = get_pipe @current_coord
    @coming_from = nil

    @inners = @current_coord.neighs.filter {|n| @@OPENINGS[get_pipe n[:coord]].include?(n[:coming_from])}.map{|n| n[:coming_from]}.map{|d| opposite_dir d}
    @borders = {@current_coord => @inners}

    @unknown = @grid.map{|x| x.count ?.}.sum

    ##                        x, y
    #@debug_coord = Coord.new 4, 2
  end

  def count_inners
    step_all_the_way

    inner = 0

    @borders.each do |c, inners|
      filled = fill_inner c.neighs.filter{|n| not inners.include? n[:coming_from]}.map{|n| n[:coord]}
    end

    return @grid.map{|x| x.count 'I'}.sum
  end

  def fill_inner coords
    filled = false

    until coords.empty?
      c = coords.pop

      pipe = get_pipe c
      next if pipe.nil? or pipe == 'I' or (pipe != '.' and @borders.include?(c))

      set_pipe c, 'I'

      filled = true

      coords += c.neighs.map{|x| x[:coord]}
    end

    return filled
  end

  def step_all_the_way
    loop do
      step

      break if @current_pipe == 'S'
    end
  end

  def step
    next_cell = get_adj(@coming_from).first

    @current_coord = next_cell[:coord]
    @coming_from   = next_cell[:coming_from]
    @current_pipe  = get_pipe @current_coord

    case @current_pipe
    when '|'
      @inners = @inners.filter{|i| i == :e or i == :w}
    when '-'
      @inners = @inners.filter{|i| i == :n or i == :s}
    when 'F'
      @inners = [:s, :e].any?{|d|d != @coming_from and @inners.include?(d)} ? [:s, :e] : [:n, :w]
    when 'L'
      @inners = [:n, :e].any?{|d|d != @coming_from and @inners.include?(d)} ? [:n, :e] : [:s, :w]
    when 'J'
      @inners = [:n, :w].any?{|d|d != @coming_from and @inners.include?(d)} ? [:n, :w] : [:s, :e]
    when '7'
      @inners = [:s, :w].any?{|d|d != @coming_from and @inners.include?(d)} ? [:s, :w] : [:n, :e]
    when 'S'
      # Do nothing
    else
      raise "Unknown pipe #{@current_pipe} (coming from: #{@coming_from})"
    end

    if @inners.empty?
      print
      raise "Emtpy inners for pipe #{@current_pipe} (coming from: #{@coming_from})"
    end
    @borders[@current_coord] = @inners unless @current_pipe == 'S'
  end

  def get_adj coming_from
    dirs = @@OPENINGS[@current_pipe] - [coming_from]

    dirs.map!{|d| opposite_dir d}

    neighs = @current_coord.neighs

    neighs.filter! do |n|
      dirs.include? n[:coming_from] and
      @@OPENINGS[get_pipe n[:coord]].include?(n[:coming_from])
    end

    neighs
  end

  def print
    @grid.each.with_index do |l,y|
      l.each_char.with_index do |c,x|
        if (! @debug_coord.nil?) and Coord.new(x, y) == @debug_coord
          STDERR.print c.green
        elsif c == 'I'
          STDERR.print c.cyan
        elsif c == 'S'
          STDERR.print c.red
        elsif @borders.include? Coord.new(x, y)
          STDERR.print c.yellow
        else
          STDERR.print c
        end
      end

      STDERR.puts
    end
  end

  private

  def get_pipe coord
    row = @grid[coord.y]
    row.nil? ? nil : row[coord.x]
  end

  def set_pipe coord, value
    @grid[coord.y][coord.x] = value
  end

  def find_start grid
    grid.each.with_index do |row, y|
      row.each_char.with_index {|cell, x| return Coord.new(x, y) if cell == ?S}
    end
  end

  def opposite_dir dir
    return case dir
    when :n
      :s
    when :s
      :n
    when :e
      :w
    when :w
      :e
    else
      nil
    end
  end

end

map = Map.new input.lines.map(&:chomp)

inners = map.count_inners
#map.print
puts inners


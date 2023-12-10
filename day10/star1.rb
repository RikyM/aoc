#!/usr/bin/env ruby

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
end

class Map
  attr_reader :steps

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
    @steps = 0
  end

  def step_all_the_way
    loop do
      step

      break if @current_pipe == 'S'
    end
  end

  def step
    @steps += 1
    next_cell = get_adj(@coming_from).first

    @current_coord = next_cell[:coord]
    @coming_from   = next_cell[:coming_from]
    @current_pipe  = get_pipe @current_coord
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

  private

  def get_pipe coord
    @grid[coord.y][coord.x]
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

map.step_all_the_way
  
puts map.steps / 2

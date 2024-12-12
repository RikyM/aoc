# frozen_string_literal: true

class Coordinate
  attr_reader :row, :column

  def initialize row, column
    @row = row
    @column = column
  end

  def self.all_directions
    [
      :up,
      :up_right,
      :right,
      :down_right,
      :down,
      :down_left,
      :left,
      :up_left
    ]
  end

  # Resetting the values is faster than creating a new object
  #   Just make sure you don't need to use the old values again ;)
  def set! row, column
    @row = row
    @column = column
    self
  end

  def move! direction, steps=1
    case direction
    when :up
      @row -= steps
    when :up_right
      @row -= steps
      @column += steps
    when :right
      @column += steps
    when :down_right
      @row +=steps
      @column += steps
    when :down
      @row += steps
    when :down_left
      @row += steps
      @column -= steps
    when :left
      @column -= steps
    when :up_left
      @row -= steps
      @column -= steps
    else
      raise "Wrong direction #{direction}"
    end
  end

  def move direction, steps=1
    new_coord = Coordinate.new(@row, @column)
    new_coord.move! direction, steps
    new_coord
  end

  def + other
    Coordinate.new(@row + other.row, @column + other.column)
  end

  def neighs
    [
      move( :up),
      move(:right),
      move(:left),
      move(:down)
    ]
  end

  def oriented_neighs
    res = {}
    [:up, :right, :left, :down].each{|dir| res[dir] = move dir}
    res
  end

  def inspect
    "[#{@row}, #{@column}]"
  end

  def to_s
    inspect
  end

  def ==(other)
    @row == other.row && @column == other.column
  end

  def eql?(other)
    self == other
  end

  def hash
    [row, column].hash
  end

  def in_range? range
    range.include? @row and range.include? @column
  end
end


class Edge
  attr_reader :orientation, :in_side

  def initialize ul_corner, orientation, in_side
    @ul_corner = ul_corner
    @orientation = orientation
    @in_side = in_side
  end

  def row
    @ul_corner.row
  end

  def column
    @ul_corner.column
  end

  def self.of_coord_going coord, direction
    case direction
    when :up
      return new coord, :horizontal, direction
    when :right
      return new coord.move(:right), :vertical, direction
    when :down
      return new coord.move(:down), :horizontal, direction
    when :left
      return new coord, :vertical, direction
    else
      raise "Unknown direction #{direction}"
    end
  end

  def neighs
    if @orientation == :vertical
      [
        Edge.new(@ul_corner.move(:up), :vertical, @in_side),
        Edge.new(@ul_corner.move(:down), :vertical, @in_side)]
    else
      [
        Edge.new(@ul_corner.move(:left), :horizontal, @in_side),
        Edge.new(@ul_corner.move(:right), :horizontal, @in_side)]
    end
  end

  def movable_directions
    if @orientation == :vertical
      [:up, :down]
    else
      [:left, :right]
    end
  end

  def move direction
    Edge.new(@ul_corner.move(direction), orientation, @in_side)
  end

  def ==(other)
    @ul_corner == other and @orientation == other.orientation and @in_side == other.in_side
  end

  def eql?(other)
    self == other
  end

  def hash
    [@ul_corner, @orientation, @in_side].hash
  end
end


class Grid
  def initialize
    @grid = []
  end

  def << line
    @grid << line
  end

  def size
    @grid.size
  end

  def get coord
    row = coord.row
    column = coord.column

    return nil if row < 0 || column < 0
    begin
      @grid[row][column]
    rescue
      nil
    end
  end
end

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

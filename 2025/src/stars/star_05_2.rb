# frozen_string_literal: true

require_relative '../super_star'

class SortedRanges

  class RangeItem
    def initialize range
      @range = range
      @left = nil
      @right = nil
    end

    def to_list list=[]
      @left.to_list list unless @left.nil?
      list << @range
      @right.to_list list unless @right.nil?
      list
    end

    def add range
      if @range.overlaps? range
        @range.merge! range

        children = []
        @left.to_list children unless @left.nil?
        @right.to_list children unless @right.nil?

        @left = nil
        @right = nil

        children.each{|c| add c}
        return
      end

      if range.start < @range.start
        if @left.nil?
          @left = RangeItem.new range
        else
          @left.add range
        end
      else
        if @right.nil?
          @right = RangeItem.new range
        else
          @right.add range
        end
      end
    end

    def size
      total_size = @range.size
      total_size += @left.size unless @left.nil?
      total_size += @right.size unless @right.nil?
      total_size
    end
  end

  def initialize
    @root = nil
  end

  def add start, stop
    range = Range.new start, stop

    if @root.nil?
      @root = RangeItem.new(range)
    else
      @root.add range
    end
  end

  def size
    @root.nil? ? 0 : @root.size
  end
end
class Range

  attr_reader :start, :stop

  def initialize start, stop
    @start = start
    @stop = stop
  end

  def totally_after? other
    @start < other.stop
  end

  def overlaps? other
    Range.number_between(@start, other.start, other.stop) or
      Range.number_between(@stop, other.start, other.stop) or
      Range.number_between(other.start, @start, @stop) or
      Range.number_between(other.stop, @start, @stop)
  end

  def merge! other
    @start = other.start if other.start < @start
    @stop = other.stop if other.stop > @stop
  end

  def size
    @stop - @start + 1
  end

  private

  def self.number_between n, start, stop
    n >= start and n <= stop
  end

end

class Star < SuperStar
  def initialize
    super('5', '2')
  end

  def run(input)
    ranges = SortedRanges.new

    input.each_line do |line|
      extremes = line.split(?-)
      break if extremes.size != 2

      ranges.add extremes[0].to_i, extremes[1].to_i
    end

    ranges.size
  end
end
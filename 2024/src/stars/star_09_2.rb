# frozen_string_literal: true

require_relative '../super_star'

class BlockRange
  attr_reader :start, :end, :file_id

  def initialize(file_id, start, ending)
    @start = start
    @end = ending  # End is excluded
    @file_id = file_id
  end

  def eat_space(size_to_eat)
    return nil if size_to_eat == size

    BlockRange.new(@file_id, @start + size_to_eat, @end)
  end

  def eat_space!(size_to_eat)
    @start += size_to_eat
  end

  def move!(new_start)
    my_size = size
    @start = new_start
    @end = new_start + my_size
  end

  def score
    (@start...@end).map{|i| i * @file_id }.sum
  end

  def to_s
    "(#{@file_id})[#{@start} - #{@end}]"
  end

  def inspect
    to_s
  end

  def == other
    @start == other.start && @end == other.end && @file_id == other.file_id
  end

  def eql?(other)
    self == other
  end

  def size()
    @end - @start
  end
end

class Star < SuperStar
  def initialize
    super(9, 2)
  end
  def run(input)
    file = true
    files = []
    spaces = []

    file_id = 0
    block_start = 0
    input.each_line do |line|
      line.each_char do |char|
        n_blocks = char.to_i
        if n_blocks == 0
          file ^= true
          next
        end

        if file
          files << BlockRange.new(file_id, block_start, block_start + n_blocks)
          file_id += 1
        else
          spaces << BlockRange.new(nil, block_start, block_start + n_blocks)
        end

        block_start += n_blocks

        file ^= true
      end
    end

    files.sort_by(&:file_id).reverse.each do |f|
      # TODO We can do better than filtering all the spaces each time
      target_space = spaces.filter{|s| s.start < f.start && s.size >= f.size}
                           .min_by(&:start)

      unless target_space.nil?
        f.move!(target_space.start)
        target_space.eat_space! f.size
      end

    end

    files.map(&:score).sum
  end
end

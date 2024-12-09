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

  def move!(new_start, size_to_move)
    my_size = size
    raise "Can't expand file" if size_to_move > my_size

    if size_to_move < my_size
      remainder = BlockRange.new(@file_id, @start, @start + my_size - size_to_move)
    else
      remainder = nil
    end

    @start = new_start
    @end = new_start + size_to_move

    remainder
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
    super(9, 1)
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

    analyzing_block = nil
    first_space = nil
    until spaces.empty?
      if first_space.nil?
        first_space = spaces.shift
      end
      if analyzing_block.nil?
        analyzing_block = files.pop
      end

      if first_space.start > analyzing_block.start
        files.unshift analyzing_block
        break
      end

      chunk_size_to_move = [first_space.size, analyzing_block.size].min

      remaining_chunk = analyzing_block.move!(first_space.start, chunk_size_to_move)
      first_space = first_space.eat_space(chunk_size_to_move)

      files.unshift analyzing_block
      analyzing_block = remaining_chunk
    end

    files.map(&:score).sum
  end
end

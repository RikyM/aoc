# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize grid_size=70, corrupted=1024
    super(18, 2)
    @grid_size = grid_size
    @corrupted = corrupted
  end

  def run(input)
    bytes = []
    input.each_line do |line|
      bytes << Coordinate.new(*line.split(?,).map(&:to_i).reverse)
    end

    corrupted = Set.new(bytes[0...@corrupted])
    next_to_corrupt = @corrupted-1

    end_position = Coordinate.new @grid_size, @grid_size

    while can_reach? end_position, corrupted
      next_to_corrupt += 1
      corrupted << bytes[next_to_corrupt]
    end

    last_corrupted = bytes[next_to_corrupt]
    [last_corrupted.column, last_corrupted.row].map(&:to_s).join(?,)
  end

  def can_reach?(end_position, corrupted)
    start_position = Coordinate.new 0, 0
    to_visit = [start_position]
    valid_range = (0..@grid_size)

    seen = Set.new [start_position]

    until to_visit.empty?
      visiting = to_visit.pop
      next if visiting == end_position

      visiting.neighs
              .filter{|n| n.in_range? valid_range and not corrupted.include?(n) and not seen.include?(n)}
              .each do |n|
        return true if n == end_position
        seen << n
        to_visit << n
      end
    end

    false
  end
end

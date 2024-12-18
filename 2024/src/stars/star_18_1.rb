# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize grid_size=70, corrupted=1024
    super(18, 1)
    @grid_size = grid_size
    @corrupted = corrupted
  end

  def run(input)
    bytes = []
    input.each_line do |line|
      bytes << Coordinate.new(*line.split(?,).map(&:to_i).reverse)
    end

    corrupted = Set.new(bytes[0...@corrupted])

    start_position = Coordinate.new 0, 0
    end_position = Coordinate.new @grid_size, @grid_size


    costs = {start_position => 0}
    to_visit = [start_position]
    valid_range = (0..@grid_size)

    until to_visit.empty?
      visiting = to_visit.pop
      next if visiting == end_position

      visiting.neighs
              .filter{|n| n.in_range? valid_range and not corrupted.include?(n)}
              .each do |n|
        cost = costs[visiting] + 1
        if (not costs.include?(n)) or (costs.include? n and costs[n] > cost)
          costs[n] = cost
          to_visit << n
        end
      end
    end

    costs[end_position]
  end
end

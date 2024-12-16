# frozen_string_literal: true

require 'colorize'
require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize
    super(16, 1)
  end

  def run(input)
    row = 0
    walls = Set.new
    reindeer = nil
    end_tile = nil
    input.each_line do |line|
      line.each_char.with_index do |char, column|
        case char
        when /#/
          walls << Coordinate.new(row, column)
        when /S/
          reindeer = Coordinate.new(row, column)
        when /E/
          end_tile = Coordinate.new(row, column)
        else
          # Empty space
        end
      end
      row += 1
    end

    costs = {reindeer => 0}
    to_visit = [{reindeer: reindeer, direction: :right}]

    until to_visit.empty?
      visiting = to_visit.pop
      next if visiting[:reindeer] == end_tile

      visiting[:reindeer].oriented_neighs
              .filter{|d, n| not walls.include? n}
              .each_pair do |d, n|
                cost = 1 + rotation_cost_from_to(visiting[:direction], d)
                total_cost = cost + costs[visiting[:reindeer]]
                if (not costs.include?(n)) or (costs.include? n and costs[n] > total_cost)
                  costs[n] = cost + costs[visiting[:reindeer]]
                  to_visit << {reindeer: n, direction: d}
                end
              end
    end

    costs[end_tile]
  end

  private

  def rotation_cost_from_to(from, to)
    return 0 if from == to
    1000
  end
end
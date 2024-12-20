# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize min_cheat = 100
    super(20, 1)
    @min_cheat = min_cheat
  end

  def run(input)
    end_pos = nil

    walls = Set.new

    row = 0
    input.each_line do |line|
      line.each_char.with_index do |c, column|
        coord = Coordinate.new row, column
        case c
        when ?#
          walls << coord
        when ?E
          end_pos = coord
        end
      end
      row += 1
    end

    adj_walls = {}
    distances = {end_pos => 0}
    curr_pos = end_pos
    d = 1
    prev_pos = end_pos
    until curr_pos.nil?
      next_pos = nil
      curr_pos.neighs.each do |n|
        if walls.include? n
          adj = adj_walls[n]
          if adj.nil?
            adj = []
            adj_walls[n] = adj
          end
          adj << curr_pos
        elsif n != prev_pos
          distances[n] = d
          next_pos = n
        end
      end

      prev_pos = curr_pos
      curr_pos = next_pos


      d += 1
    end

    adj_walls.keys
             .map{|w| cheat_starting_at(w, adj_walls, distances)}
             .count{|x| x >= @min_cheat}
  end

  def cheat_starting_at(wall, adj_walls, distances)
    adj = adj_walls[wall].map{|p| distances[p]}
    adj.max - adj.min - 2
  end
end
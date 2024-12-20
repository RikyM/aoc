# frozen_string_literal: true

require 'set'

require_relative '../super_star'
require_relative '../lib/grid'

class Star < SuperStar
  def initialize min_cheat = 100
    super(20, 2)
    @min_cheat = min_cheat

    @cheats = {}
    (-20..20).each do |row|
      (-20..20).each do |col|
        cost = row.abs + col.abs
        @cheats[Coordinate.new(row, col)] = cost if cost <= 20
      end
    end
  end

  def run(input)
    end_pos = nil

    track = Set.new

    row = 0
    input.each_line do |line|
      line.each_char.with_index do |c, column|
        coord = Coordinate.new row, column
        case c
        when /[S.]/
          track << coord
        when ?E
          track << coord
          end_pos = coord
        end
      end
      row += 1
    end

    distances = {end_pos => 0}
    curr_pos = end_pos
    d = 1
    prev_pos = end_pos
    until curr_pos.nil?
      next_pos = nil
      curr_pos.neighs.each do |n|
        if n != prev_pos and track.include? n
          distances[n] = d
          next_pos = n
        end
      end

      prev_pos = curr_pos
      curr_pos = next_pos
      d += 1
    end

    track.map{|p| cheat_starting_at p, distances}.sum
  end

  def cheat_starting_at(start_pos, distances)
    count = 0
    start_distance = distances[start_pos]
    @cheats.each_pair do |delta, cost|
      end_pos = start_pos + delta
      end_distance = distances[end_pos]
      next if end_distance.nil?

      count += 1 if start_distance - end_distance - cost >= @min_cheat
    end

    count
  end
end

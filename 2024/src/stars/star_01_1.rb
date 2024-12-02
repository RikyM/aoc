# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar

  def initialize
    super(1, 1)
  end

  def run(input)
    left = []
    right = []

    input.each_line do |line|
      l, r = line.split(' ')

      left << l.to_i
      right << r.to_i
    end

    left.sort
        .zip(right.sort)
        .map{|e| (e[1] - e[0]).abs}
        .sum
  end
end
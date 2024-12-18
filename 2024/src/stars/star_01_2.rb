# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar

  def initialize
    super(1, 2)
  end

  def run(input)
    left = []
    right = []

    input.each_line do |line|
      l, r = line.split(' ')

      left << l.to_i
      right << r.to_i
    end

    similarity(left, right)
  end

  private

  def similarity(left, right)
    right_counts = count(right)

    left.map{|n| n * right_counts[n]}.sum
  end

  def count(numbers)
    counts = Hash.new(0)

    numbers.each do |n|
      counts[n] += 1
    end

    counts
  end
end
# frozen_string_literal: true

class Star
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

    left.reduce(0) do |similarity, n|
      similarity + (n * right_counts[n])
    end
  end

  def count(numbers)
    counts = Hash.new(0)

    numbers.each do |n|
      counts[n] += 1
    end

    counts
  end
end
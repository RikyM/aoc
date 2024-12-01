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

    left.sort.zip(right.sort).reduce(0){|t, e| t + (e[1] - e[0]).abs}
  end
end
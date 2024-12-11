# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super(11, 1)
  end

  def run(input)
    stones = []
    input.each_line do |line|
      stones = line.split.map(&:to_i)
    end

    25.times do |s|
      stones = Star.blink(stones)
    end

    stones.size
  end

  private

  def self.blink(stones)
    new_stones = []

    stones.each do |s|
      digits_n = count_digits(s)

      if s == 0
        new_stones << 1
      elsif digits_n.even?
        divisor = 10 ** (digits_n/2)
        new_stones << s / divisor
        new_stones << s % divisor
      else
        new_stones << s * 2024
      end
    end

    new_stones
  end

  def self.count_digits(n)
    return 1 if n == 0
    Math.log10(n).floor + 1
  end
end

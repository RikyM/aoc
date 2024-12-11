# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super(11, 2)
    @memo = {}
  end

  def run(input)
    stones = []
    input.each_line do |line|
      stones = line.split.map(&:to_i)
    end

    stones.map{|s| blink(s, 75)}.sum
  end

  private

  def blink(stone, remaining_blinks)
    return 1 if remaining_blinks == 0

    memo_key = [stone, remaining_blinks]
    cached_value = @memo[memo_key]
    return cached_value unless cached_value.nil?

    digits_n = Star.count_digits(stone)

    if stone == 0
      res = blink(1, remaining_blinks-1)
    elsif digits_n.even?
      divisor = 10 ** (digits_n/2)
      res = blink(stone / divisor, remaining_blinks-1) + blink(stone % divisor, remaining_blinks-1)
    else
      res = blink(stone * 2024, remaining_blinks-1)
    end

    @memo[memo_key] = res
  end

  def self.count_digits(n)
    return 1 if n == 0
    Math.log10(n).floor + 1
  end
end

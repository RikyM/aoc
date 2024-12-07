# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super(7, 2)
  end

  def run(input)
    res = 0
    input.each_line do |line|
      test_value, ops_str = line.split(': ')
      test_value = test_value.to_i
      ops = ops_str.split.map(&:to_i)

      res += test_value if can_solve?(test_value, ops)
    end

    res
  end

  private

  def self.concat(a, b)
    digits = Math.log10(b)
    digits = digits == digits.to_i ? digits + 1 : digits.ceil

    a * (10 ** digits) + b
  end

  def can_solve? test_value, ops, current_total = 0
    return false if current_total > test_value
    if ops.empty?
      return true if current_total == test_value
      return false
    end

    head, *tail = ops

    can_solve? test_value, tail, current_total * head or
      can_solve? test_value, tail, current_total + head or
      can_solve? test_value, tail, Star.concat(current_total, head)
  end
end

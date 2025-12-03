# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super('3', '1')
  end

  def run(input)
    joltage = 0

    input.each_line do |line|
      max_dec = -1
      max_unit = -1

      length = line.size

      line.each_char.with_index do |char, index|
        digit = char.to_i

        if (index < length - 1) and (digit > max_dec)
          max_dec = digit
          max_unit = -1
        elsif digit > max_unit
          max_unit = digit
        end
      end

      joltage += (max_dec * 10) + max_unit
    end

    joltage
  end
end
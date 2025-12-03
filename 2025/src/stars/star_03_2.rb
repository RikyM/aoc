# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar

  NEEDED_BATTERIES = 12
  def initialize
    super('3', '2')
  end

  def run(input)
    joltage = 0

    input.each_line do |line|
      batteries_on = Array.new(NEEDED_BATTERIES, -1)

      bank_length = line.size

      line.each_char.with_index do |char, index|
        remaining = bank_length - index

        digit = char.to_i

        starting_pos = NEEDED_BATTERIES - remaining
        starting_pos = 0 if starting_pos < 0

        (starting_pos...batteries_on.size-1).each do |battery_pos|
          if digit > batteries_on[battery_pos]
            batteries_on[battery_pos] = digit

            (battery_pos + 1..NEEDED_BATTERIES).each {|j| batteries_on[j] = -1}
            break
          end
        end


      end

      joltage += batteries_on
                   .filter{|b| b >= 0}
                   .reduce(0){|tot, b| tot * 10 + b}
    end

    joltage
  end
end
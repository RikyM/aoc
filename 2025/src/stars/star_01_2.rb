# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super('1', '2')
  end

  def run(input)
    pos = 50
    pos_was_0 = false
    zeroes = 0

    input.each_line do |line|
      distance = line[1..-1].to_i
      distance *= -1 if line[0] == ?L

      pos = pos + distance

      if pos <= 0
        zeroes += (pos.abs / 100) + 1
        zeroes -= 1 if pos_was_0
      elsif pos >= 100
        zeroes += pos / 100
      end

      pos %= 100
      pos_was_0 = pos == 0
    end

    zeroes
  end
end
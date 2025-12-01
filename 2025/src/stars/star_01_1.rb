# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super('1', '1')
  end

  def run(input)
    pos = 50
    zeroes = 0

    input.each_line do |line|
      distance = line[1..-1].to_i
      distance *= -1 if line[0] == ?L

      pos = (pos + distance) % 100
      zeroes += 1 if pos == 0
    end

    zeroes
  end
end
# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super('6', '2')
  end

  def run(input)
    numbers = []
    ops = []

    input.each_line do |line|
      line.chars.each.with_index do |c, i|
        case c
        when / /
          next
        when ?*
          ops << :*
        when ?+
          ops << :+
        else
          prev = numbers[i]
          prev = 0 if prev.nil?
          numbers[i] = prev * 10 + c.to_i
        end
      end
    end

    i = 0
    total = 0
    ops.each do |op|
      partial = op == :* ? 1 : 0

      until numbers[i].nil? or i >= numbers.size do
        partial = partial.send(op, numbers[i])
        i += 1
      end

      while numbers[i].nil? and i < numbers.size do
        # Discard nil values
        i += 1
      end

      total += partial
    end

    total
  end
end
# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar

  def initialize
    super(3, 1)
  end

  def run(input)
    sum = 0

    input.each_line do |line|
      muls = line.gsub /.*?mul\((\d+),(\d+)\).*?/, '\1,\2-'  # Convert multiplications to op0,op1-other_op0,other_op1
      muls.gsub! /-\D*$/, ''  # Clean end of line
      sum += muls.split(?-)
                 .map{|m| m.split(?,)
                           .map(&:to_i)
                           .reduce(&:*)
                 }.sum
    end

    sum
  end
end

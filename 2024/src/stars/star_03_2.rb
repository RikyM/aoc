require_relative '../super_star'

class Star < SuperStar

  def initialize
    super(3, 2)
  end

  def run(input)
    expr = ''
    input.each_line do |line|
      expr += line
    end

    expr.gsub! /don't\(\).*?(do\(\)|$)/, ''  # Remove don't regions
    expr.gsub! /.*?mul\((\d+),(\d+)\).*?/, '\1,\2-'  # Convert multiplications to op0,op1-other_op0,other_op1
    expr.gsub! /-\D*$/, ''  # Clean end of line

    expr.split(?-)
        .map{|m| m.split(?,)
                  .map(&:to_i)
                  .reduce(&:*)
        }.sum
  end
end

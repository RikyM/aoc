# frozen_string_literal: true

require_relative '../super_star'

class Total
  attr_reader :result

  def initialize
    @sum = 0
    @mul = 1
    @result = 0
  end

  def add n
    case n
    when ?+
      @result = @sum
    when ?*
      @result = @mul
    else
      @sum += n.to_i
      @mul *= n.to_i
    end
  end
end

class Star < SuperStar
  def initialize
    super('6', '1')
  end

  def run(input)
    results = []

    input.each_line do |line|
      line.strip.split(/\s+/).map.with_index do |n, i|
        res = results[i]
        if res.nil?
          res = Total.new
          results[i] = res
        end

        res.add n
      end
    end

    results.map(&:result).sum
  end
end
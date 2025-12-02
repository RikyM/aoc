# frozen_string_literal: true

require_relative '../super_star'

class Range
  def initialize(start, stop)
    @start = start
    @stop = stop
  end

  def self.from_string str
    extremes = str.split(?-)
    start = extremes[0].to_i
    stop = extremes[1].to_i
    Range.new(start, stop)
  end

  def invalids_sum
    (@start..@stop).select{|n| not (Range.is_valid? n)}
                   .sum
  end

  def self.is_valid? n
    n_digits = self.n_digits n
    return true if n_digits.odd?

    proposed_period = n_digits / 2
    first_half = (n % (10 ** proposed_period))
    second_half = (n % (10 ** (proposed_period * 2))) / (10 ** proposed_period)

    first_half != second_half
  end

  def self.n_digits n
    log = Math.log(n, 10)
    return log.to_i + 1 if log == log.to_i
    return log.ceil
  end
end

class Star < SuperStar
  def initialize
    super('2', '1')
  end

  def run(input)
    input.each_line do |line|
      return line.split(?,).map{|r| Range.from_string r}
               .map(&:invalids_sum)
               .sum
    end
  end
end
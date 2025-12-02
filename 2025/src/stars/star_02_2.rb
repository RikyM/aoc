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
    return true if n_digits == 1

    (1...n_digits).each do |proposed_period|
      next if n_digits % proposed_period != 0

      invalid = (1..(n_digits / proposed_period))
                  .map{|i| (n % (10 ** (proposed_period * (i)))) / (10 ** (proposed_period * (i-1)))}
                  .uniq.size == 1

      return false if invalid
    end

    true
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

      -1
  end
end
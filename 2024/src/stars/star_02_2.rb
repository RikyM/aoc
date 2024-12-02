# frozen_string_literal: true

require_relative '../super_star'

class Report
  def initialize levels
    @levels = levels
  end

  def is_safe?
    (-1...@levels.size).each do |excluded|
      return true if is_safe_skipping? @levels, excluded
    end
    false
  end

  private

  def is_safe_skipping? levels, skipping
    prev = nil

    (1...@levels.size).each do |i|
      next if i == skipping or (i == 1 and skipping == 0)

      prev_index = i-1
      prev_index = i-2 if prev_index == skipping

      diff = levels[i] - levels[prev_index]

      return false unless diff.abs in (1..3)
      return false if prev != nil and (prev * diff) < 0
      prev = diff
    end

    true
  end
end

class Star < SuperStar
  def initialize
    super(2, 2)
  end

  def run(input)
    count = 0

    input.each_line do |line|
      count += 1 if Report.new(line.split.map(&:to_i)).is_safe?
    end

    count
  end
end

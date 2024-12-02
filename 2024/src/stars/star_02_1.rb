# frozen_string_literal: true

require_relative '../super_star'

class Report
  def initialize levels
    @levels = levels
  end

  def is_safe?
    differences = @levels[1..-1].map.with_index do |level, index|
      level - @levels[index]
    end

    differences.all? {|d| 1 <= d.abs and d.abs <= 3} and
      (differences.all? {|d| d.positive?} or differences.all? {|d| d.negative?})
  end
end

class Star < SuperStar
  def initialize
    super(2, 1)
  end

  def run(input)
    count = 0

    input.each_line do |line|
      count += 1 if Report.new(line.split.map(&:to_i)).is_safe?
    end

    count
  end
end

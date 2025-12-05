# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super('5', '1')
  end

  def run(input)
    good_ranges = []
    good_ingredients_count = 0
    input.each_line do |line|
      extremes = line.split(?-)
      if extremes.size == 2
        good_ranges << [extremes[0].to_i, extremes[1].to_i]
      elsif line.empty?
        # Do nothing
      else
        ingredient = line.to_i
        if good_ranges.any? {|r| ingredient >= r[0]  and ingredient <= r[1]}
          good_ingredients_count += 1
        end
      end
    end

    good_ingredients_count
  end
end
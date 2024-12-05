# frozen_string_literal: true

require 'set'
require_relative '../super_star'

class Star < SuperStar
  def initialize
    super(5, 1)

    @rules = Hash.new{|h, k| h[k] = []}
  end

  def run(input)
    result = 0

    input.each_line do |line|
      case line
      when /.*\|.*/
        add_rule(*line.split(?|).map(&:to_i))
      when /^$/
        # Do nothing
      else
        result += pages_value(line.split(?,).map(&:to_i))
      end
    end

    result
  end

  private

  def add_rule(first, last)
    @rules[first] << last
  end

  def pages_value(pages)
    return 0 unless is_sorted?(pages)

    pages[pages.size / 2.0].ceil
  end

  def is_sorted?(pages)
    seen = Set.new

    pages.each do |page|
      return false if @rules[page].any? {|p| seen.include? p}
      seen << page
    end

    true
  end
end

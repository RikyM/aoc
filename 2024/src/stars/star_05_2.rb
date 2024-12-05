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
    pages = sort(pages)

    pages[pages.size / 2.0].ceil
  end

  def sort(pages)
    seen = Set.new
    was_unsorted = false

    pages.size.times do |i|
      page = pages[i]
      after = @rules[page].filter{|p| seen.include? p}
      unless after.empty?
        should_be_before = after.map{|p| pages.find_index p}.min
        pages.insert(should_be_before, pages.delete_at(i))
        was_unsorted = true
      end

      seen << page
    end

    was_unsorted ? pages : [0]
  end
end

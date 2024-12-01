# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar

  def initialize
    super('DAY_PLACEHOLDER', 'STAR_PLACEHOLDER')
  end

  def run(input)
    input.each_line do |line|
      puts line
    end

    -1
  end
end
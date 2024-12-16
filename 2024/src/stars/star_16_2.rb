# frozen_string_literal: true

require_relative '../super_star'

class Star < SuperStar
  def initialize
    super(16, 2)
  end

  def run(input)
    input.each_line do |line|
      puts line
    end

    -1
  end
end
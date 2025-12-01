# frozen_string_literal: true

class InputString
  def initialize(input)
    @input = input
  end

  def each_line
    @input.each_line {|l| yield l.chomp}
  end
end

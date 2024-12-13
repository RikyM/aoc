# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'

class Prize
  def initialize(position, buttons)
    @position = position
    @button_a, @button_b = *buttons
  end

  def min_tokens
    res = 60000000
    found = false

    (0..100).each do |a_pressed|
      (0..100).each do |b_pressed|
        pos = Coordinate.new(
          @button_a.row    * a_pressed + @button_b.row    * b_pressed,
          @button_a.column * a_pressed + @button_b.column * b_pressed)

        if pos == @position
          found = true
          res = [res, a_pressed * 3 + b_pressed].min
        end
      end
    end

    found ? res : 0
  end
end

class Star < SuperStar
  def initialize
    super(13, 1)
  end

  def run(input)
    buttons = []
    prizes = []

    input.each_line do |line|
      case line
      when /^Button/
        x, y = *line.split(': ').last.split(', ').map{|m| m.sub(/.*\+/, '').to_i}
        buttons << Coordinate.new(x, y)
      when /Prize:/
        x, y = *line.split(': ').last.split(', ').map{|m| m.sub(/.*=/, '').to_i}
        prizes << Prize.new(Coordinate.new(x, y) , buttons)
        buttons = []
      end
    end

    prizes.map(&:min_tokens).sum
  end
end

# frozen_string_literal: true

require_relative '../super_star'
require_relative '../lib/grid'

class Prize
  def initialize(position, buttons)
    @position = position
    @button_a, @button_b = *buttons
  end

  def min_tokens
    den = (@button_a.row * @button_b.column) - (@button_a.column * @button_b.row)
    return 0 if den == 0

    nom = (@button_a.row * @position.column) - (@button_a.column * @position.row)
    b = (nom + 0.0) / den
    a = (@position.row - (b * @button_b.row)) / @button_a.row
    return 0 if a != a.to_i or b != b.to_i
    (a * 3 + b).to_i
  end

end

class Star < SuperStar
  def initialize
    super(13, 2)
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
        x, y = *line.split(': ').last.split(', ').map{|m| m.sub(/.*=/, '').to_i + 10000000000000}
        prizes << Prize.new(Coordinate.new(x, y) , buttons)
        buttons = []
      end
    end

    prizes.map(&:min_tokens).sum
  end
end

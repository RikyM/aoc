# frozen_string_literal: true

require_relative '../helper/test_star'
require_relative '../../src/stars/star_16_2'
require_relative '../../src/lib/grid'

day = 16
star_n = 2

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(45)
  end

  it 'finds nearest in' do
    corners = Set.new
    (0..8).step(2).each do |row|
      (0..8).step(2).each do |column|
        corners << Coordinate.new(row, column)
      end
    end

    c = Coordinate.new(4, 4)

    expect(Star.nearest_in_to(corners, c, :up)).to eq([Coordinate.new(2, 4), 2])
    expect(Star.nearest_in_to(corners, c, :down)).to eq([Coordinate.new(6, 4), 2])
    expect(Star.nearest_in_to(corners, c, :right)).to eq([Coordinate.new(4, 6), 2])
    expect(Star.nearest_in_to(corners, c, :left)).to eq([Coordinate.new(4, 2), 2])
  end
end
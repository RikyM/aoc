# frozen_string_literal: true

require_relative '../helper/test_star'
require_relative '../../src/lib/grid'
require_relative '../../src/stars/star_08_1'

day = 8
star_n = 1

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(14)
  end

  it 'Runs easy example' do
    input = '..........
...#......
#.........
....a.....
........a.
.....a....
..#.......
......A...
..........
..........'

    output = star.run input
    expect(output).to eq(4)
  end

  describe 'antinodes' do
    it 'calculates the antinode of two antennas \\' do
      antennas = [Coordinate.new(3, 4), Coordinate.new(5,5)]
      expected_antinodes = [Coordinate.new(1, 3), Coordinate.new(7, 6)]
      actual_antinodes = Star.antinodes_of *antennas
      expect(actual_antinodes).to eq(expected_antinodes)
    end

    it 'calculates the antinode of two antennas /' do
      antennas = [Coordinate.new(3, 5), Coordinate.new(5,4)]
      expected_antinodes = [Coordinate.new(1, 6), Coordinate.new(7, 3)]
      actual_antinodes = Star.antinodes_of *antennas
      expect(actual_antinodes).to eq(expected_antinodes)
    end

    it 'calculates the antinode of two antennas -' do
      antennas = [Coordinate.new(3, 5), Coordinate.new(3,4)]
      expected_antinodes = [Coordinate.new(3, 6), Coordinate.new(3, 3)]
      actual_antinodes = Star.antinodes_of *antennas
      expect(actual_antinodes).to eq(expected_antinodes)
    end

    it 'calculates the antinode of two antennas |' do
      antennas = [Coordinate.new(3, 5), Coordinate.new(5,5)]
      expected_antinodes = [Coordinate.new(1, 5), Coordinate.new(7, 5)]
      actual_antinodes = Star.antinodes_of *antennas
      expect(actual_antinodes).to eq(expected_antinodes)
    end
  end
end
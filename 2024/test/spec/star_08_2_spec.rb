# frozen_string_literal: true

require_relative '../helper/test_star'
require_relative '../../src/lib/grid'
require_relative '../../src/stars/star_08_2'

day = 8
star_n = 2

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(34)
  end

  it 'Runs easy example' do
    input = 'T....#....
...T......
.T....#...
.........#
..#.......
..........
...#......
..........
....#.....
..........'

    output = star.run input
    expect(output).to eq(9)
  end

  describe 'antinodes' do
    it 'calculates the antinode of two antennas \\' do
      expected_antinodes = [
        Coordinate.new(1, 1),
        Coordinate.new(3, 4),
        Coordinate.new(5, 7),
      ]

      antennas = [Coordinate.new(3, 4), Coordinate.new(5,7)]
      expect(Star.antinode_of(*antennas).take(3)).to eq(expected_antinodes)

      antennas = [Coordinate.new(5, 7), Coordinate.new(7,10)]
      expect(Star.antinode_of(*antennas).take(3)).to eq(expected_antinodes)
    end

    it 'calculates the antinode of two antennas /' do
      expected_antinodes = [
        Coordinate.new(1, 6),
        Coordinate.new(3, 5),
        Coordinate.new(5, 4),
      ]

      antennas = [Coordinate.new(3, 5), Coordinate.new(5,4)]
      expect(Star.antinode_of(*antennas).take(3)).to eq(expected_antinodes)

      antennas = [Coordinate.new(5, 4), Coordinate.new(7,3)]
      expect(Star.antinode_of(*antennas).take(3)).to eq(expected_antinodes)
    end

    it 'calculates the antinode of two antennas -' do
      antennas = [Coordinate.new(3, 5), Coordinate.new(3,3)]
      expected_antinodes = [
        Coordinate.new(3, 1),
        Coordinate.new(3, 3),
        Coordinate.new(3, 5),
      ]
      expect(Star.antinode_of(*antennas).take(3)).to eq(expected_antinodes)
    end

    it 'calculates the antinode of two antennas |' do
      antennas = [Coordinate.new(3, 5), Coordinate.new(5,5)]
      expected_antinodes = [
        Coordinate.new(1, 5),
        Coordinate.new(3, 5),
        Coordinate.new(5, 5),
      ]
      expect(Star.antinode_of(*antennas).take(3)).to eq(expected_antinodes)
    end
  end
end
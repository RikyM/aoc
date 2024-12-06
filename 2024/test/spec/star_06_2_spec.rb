# frozen_string_literal: true

require_relative '../helper/test_star'
require_relative '../../src/lib/grid'
require_relative '../../src/stars/star_06_2'

day = 6
star_n = 2

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(6)
  end

  describe 'next_obstacle' do
    guard_position = Coordinate.new(5, 5)

    obstacles = Set.new
    obstacles << Coordinate.new(5, 1)
    obstacles << Coordinate.new(5, 3)
    obstacles << Coordinate.new(5, 7)
    obstacles << Coordinate.new(5, 9)
    obstacles << Coordinate.new(1, 5)
    obstacles << Coordinate.new(3, 5)
    obstacles << Coordinate.new(7, 5)
    obstacles << Coordinate.new(9, 5)

    it 'finds and obstacle upwards' do
      res = Star.next_obstacle(obstacles, guard_position, :up)
      expect(res).to eq(Coordinate.new(3, 5))
    end

    it 'finds and obstacle to the right' do
      res = Star.next_obstacle(obstacles, guard_position, :right)
      expect(res).to eq(Coordinate.new(5, 7))
    end

    it 'finds and obstacle downwards' do
      res = Star.next_obstacle(obstacles, guard_position, :down)
      expect(res).to eq(Coordinate.new(7, 5))
    end

    it 'finds and obstacle to the left' do
      res = Star.next_obstacle(obstacles, guard_position, :left)
      expect(res).to eq(Coordinate.new(5, 3))
    end
  end

  describe 'move_guard' do
    obstacle = Coordinate.new(5, 5)

    it 'moves correctly to up' do
      res = Star.move_guard(:up, obstacle)
      expect(res).to eq(Coordinate.new(6, 5))
    end

    it 'moves correctly to right' do
      res = Star.move_guard(:right, obstacle)
      expect(res).to eq(Coordinate.new(5, 4))
    end

    it 'moves correctly to down' do
      res = Star.move_guard(:down, obstacle)
      expect(res).to eq(Coordinate.new(4, 5))
    end

    it 'moves correctly to left' do
      res = Star.move_guard(:left, obstacle)
      expect(res).to eq(Coordinate.new(5, 6))
    end
  end
end

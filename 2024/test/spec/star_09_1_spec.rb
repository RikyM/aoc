# frozen_string_literal: true

require_relative '../helper/test_star'
require_relative '../../src/stars/star_09_1'

day = 9
star_n = 1

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(1928)
  end

  describe 'BlockRange' do
    it 'has a size' do
      r = BlockRange.new(1, 2, 2)
      expect(r.size).to eq(0)

      r = BlockRange.new(1, 2, 3)
      expect(r.size).to eq(1)

      r = BlockRange.new(1, 5, 15)
      expect(r.size).to eq(10)
    end

    it 'can move' do
      r = BlockRange.new(1, 5, 15)
      remainder = r.move! 1, 10
      expect(r).to eq(BlockRange.new(1, 1, 11))
      expect(remainder).to be_nil

      r = BlockRange.new(1, 5, 15)
      remainder = r.move! 1, 5
      expect(r).to eq(BlockRange.new(1, 1, 6))
      expect(remainder).to eql(BlockRange.new(1, 5, 10))
    end
  end
end
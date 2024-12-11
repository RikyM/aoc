# frozen_string_literal: true

require_relative '../helper/test_star'
require_relative '../../src/stars/star_11_1'

day = 11
star_n = 1

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(55312)
  end

  describe 'count_digits' do
    it 'counts 1 digit numbers' do
      expect(Star.count_digits(0)).to eql(1)
      expect(Star.count_digits(2)).to eql(1)
      expect(Star.count_digits(9)).to eql(1)
    end

    it 'counts 2 digit numbers' do
      expect(Star.count_digits(10)).to eql(2)
      expect(Star.count_digits(12)).to eql(2)
      expect(Star.count_digits(19)).to eql(2)
    end
  end
end

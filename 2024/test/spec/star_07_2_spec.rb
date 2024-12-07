# frozen_string_literal: true

require_relative '../helper/test_star'
require_relative '../../src/stars/star_07_2'

day = 7
star_n = 2

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(11387)
  end

  it 'can concatenate numbers' do
    expect(Star.concat(12, 345)).to eq(12345)
    expect(Star.concat(15, 6)).to eq(156)
    expect(Star.concat(5, 10)).to eq(510)
  end
end
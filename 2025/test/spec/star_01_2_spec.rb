# frozen_string_literal: true

require_relative '../helper/test_star'

day = '1'
star_n = '2'

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(6)
  end

  it 'Passes 10 times R' do
    output = star.run 'R1000'
    expect(output).to eq(10)
  end

  it 'Passes 10 times L' do
    output = star.run 'L1000'
    expect(output).to eq(10)
  end
end
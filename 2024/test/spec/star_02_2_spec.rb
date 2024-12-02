# frozen_string_literal: true

require_relative '../helper/test_star'

day = 2
star_n = 2

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(4)
  end

  it 'is safe removing the first element' do
    output = star.run '1 9 8 7'
    expect(output).to eq(1)

    output = star.run '1 9'
    expect(output).to eq(1)

    output = star.run '1 9 10'
    expect(output).to eq(1)
  end

  it 'is safe up' do
    output = star.run '1 -1 2 3 4'
    expect(output).to eq(1)

    output = star.run '1 2 3 -4'
    expect(output).to eq(1)

    output = star.run '1 2 3 6 9'
    expect(output).to eq(1)

    output = star.run '1 2 3 7 9'
    expect(output).to eq(0)
  end

  it 'is safe down' do
    output = star.run '4 3 2 -1 1'
    expect(output).to eq(1)

    output = star.run '3 2 1 -4'
    expect(output).to eq(1)

    output = star.run '9 6 3 2 1'
    expect(output).to eq(1)

    output = star.run '9 7 3 2 1'
    expect(output).to eq(0)
  end

  it 'is safe removing an unsuspected value' do
    output = star.run '23 21 19 20 19 17 14 13'
    expect(output).to eq(1)
  end
end
# frozen_string_literal: true

require_relative '../helper/test_star'

day = 12
star_n = 1

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(1930)
  end

  it 'Runs the simplest example' do
    input = 'AAAA
BBCD
BBCC
EEEC'

    expect(star.run input).to eq(140)
  end

  it 'Runs a simple example' do
        input = 'OOOOO
OXOXO
OOOOO
OXOXO
OOOOO
'

    expect(star.run input).to eq(772)
  end
end
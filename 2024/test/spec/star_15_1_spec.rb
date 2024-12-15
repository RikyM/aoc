# frozen_string_literal: true

require_relative '../helper/test_star'

day = 15
star_n = 1

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(10092)
  end

  it 'Runs a smaller example' do
    output = star.run '########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<'

    expect(output).to eq(2028)
  end
end
# frozen_string_literal: true

require_relative '../helper/test_star'

day = 'DAY_PLACEHOLDER'
star_n = 'STAR_PLACEHOLDER'

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(11)
  end
end
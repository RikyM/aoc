# frozen_string_literal: true

require_relative '../helper/test_star'

day = 5
star_n = 2

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(123)
  end
end
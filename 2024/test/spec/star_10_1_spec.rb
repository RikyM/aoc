# frozen_string_literal: true

require_relative '../helper/test_star'

day = 10
star_n = 1

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    output = star.run_example
    expect(output).to eq(36)
  end
end
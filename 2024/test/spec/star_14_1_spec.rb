# frozen_string_literal: true

require_relative '../helper/test_star'

day = 14
star_n = 1

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  it 'Runs the example' do
    star.require

    file_path = File.expand_path("../input/example_14.txt", File.dirname(__FILE__))
    output = Star.new(7, 11).run InputFile.new(file_path)
    expect(output).to eq(12)
  end
end
# frozen_string_literal: true

require_relative '../helper/test_star'

day = 14
star_n = 2

star = TestStar.new day, star_n

describe "Day #{day} - Star #{star_n}" do
  # The example won't generate any tree, but we can test for the robot arrangement that is most similar to one
  it 'Runs the example' do
    star.require

    file_path = File.expand_path("../input/example_14.txt", File.dirname(__FILE__))
    star = Star.new(7, 11)
    star.generate_image = false
    star.print_result = false
    output = star.run InputFile.new(file_path)
    expect(output).to eq(63)
  end
end
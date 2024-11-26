# frozen_string_literal: true

require  'rspec'

class TestStar
  def initialize(day, star)
    @day = day
    @day_s = @day.to_s.rjust(2, '0')
    @star = star
  end

  def require
    require_relative "../../src/stars/star_#{@day_s}_#{@star}"
  end

  def run(input)
    require
    s = Star.new

    s.run input
  end

  def run_with_file(input_file)
    require
    s = Star.new
    s.run File.read(File.expand_path("../input/#{input_file}", File.dirname(__FILE__)))
  end

  def run_example
    run_with_file "example_#{@day_s}_#{@star}"
  end

  def to_s
    "Day #{@day_s} - Star #{@star}"
  end
end
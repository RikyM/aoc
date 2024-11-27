# frozen_string_literal: true

require  'rspec'
require_relative '../../src/input/input_string'
require_relative '../../src/input/input_file'

class TestStar
  def initialize(day, star)
    @day = day
    @day_s = @day.to_s.rjust(2, '0')
    @star = star
    @already_required = false
  end

  def require
    unless @already_required
      require_relative "../../src/stars/star_#{@day_s}_#{@star}"
      @already_required = true
    end
  end

  def run(input)
    require
    s = Star.new
    s.run InputString.new(input)
  end

  def run_with_file(input_file)
    require
    s = Star.new
    file_path = File.expand_path("../input/#{input_file}", File.dirname(__FILE__))
    s.run InputFile.new(file_path)
  end

  def run_example
    run_with_file "example_#{@day_s}_#{@star}.txt"
  end

  def to_s
    "Day #{@day_s} - Star #{@star}"
  end
end
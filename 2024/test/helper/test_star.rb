# frozen_string_literal: true

require  'rspec'

class TestStar
  def initialize(day, star)
    @day = day
    @day_s = @day.to_s.rjust(2, '0')
    @star = star
    @already_required = false
  end

  def run_example
    file_path = File.expand_path("../input/example_#{@day_s}_#{@star}.txt", File.dirname(__FILE__))
    new_star.run_with_file file_path
  end

  def run input
    new_star.run_with_string input
  end

  private

  def require
    unless @already_required
      require_relative "../../src/stars/star_#{@day_s}_#{@star}"
      @already_required = true
    end
  end

  def new_star
    require
    Star.new
  end
end
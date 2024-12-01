# frozen_string_literal: true

require_relative 'input/input_file'

class SuperStar
  def initialize(day, star)
    @day = day
    @day_s = @day.to_s.rjust(2, '0')
    @star = star
  end

  def run_with_string(input_str)
    run InputString.new(input_str)
  end

  def run_with_file(file_path)
    run InputFile.new(file_path)
  end

  def help_the_elves
    file_path = File.expand_path("../input/input_#{@day_s}.txt", File.dirname(__FILE__))
    run_with_file  file_path
  end

  def to_s
    "Day #{@day_s} - Star #{@star}"
  end
end

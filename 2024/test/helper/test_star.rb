# frozen_string_literal: true

require  'rspec'

class TestStar
  def initialize(day, star)
    @day = day
    @day_s = @day.to_s.rjust(2, '0')
    @star = star
    @already_required = false
  end

  def run_example star_args=[]
    file_path = File.expand_path("../input/example_#{@day_s}_#{@star}.txt", File.dirname(__FILE__))
    unless File.exist? file_path
      file_path = File.expand_path("../input/example_#{@day_s}.txt", File.dirname(__FILE__))
    end

    new_star(star_args).run_with_file file_path
  end

  def run input, star_args=[]
    new_star(star_args).run_with_string input
  end

  def require
    unless @already_required
      load File.expand_path("../../../src/stars/star_#{@day_s}_#{@star}.rb", __FILE__)
      @already_required = true
    end
  end

  private

  def new_star star_args
    require
    Star.new *star_args
  end
end
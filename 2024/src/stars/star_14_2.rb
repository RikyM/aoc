# frozen_string_literal: true

require 'colorize'
require 'chunky_png'
require 'tmpdir'

require_relative '../super_star'
require_relative '../lib/grid'

class Robot
  attr_reader :position, :velocity

  def initialize(position, velocity)
    @position = position
    @velocity = velocity
  end

  def move(seconds)
    @position.+(@velocity, seconds)
  end

  def time_to_loop wrap_limits
    r = @velocity.row.lcm(wrap_limits.row) / @velocity.row
    c = @velocity.column.lcm(wrap_limits.column) / @velocity.column
    r.lcm(c)
  end
end

class Star < SuperStar
  def initialize
    super(14, 1)
    @generate_image = true
    @print_result = false
  end

  def run(input)
    if @generate_image
      image_dir = Dir.mktmpdir('aoc_robots-')
      puts "Generating images in #{image_dir}"
      at_exit { FileUtils.remove_entry(image_dir) }
    end

    robots = []
    @wrap_limits = Coordinate.new(103, 101)
    input.each_line do |line|
      pos, vel = line.split.map{|e| Coordinate.new( *e.split(?=)
                                                      .last
                                                      .split(?,)
                                                      .map(&:to_i).reverse)}
      pos.wrap_around = @wrap_limits
      r = Robot.new(pos, vel)
      robots << r
    end

    time_to_loop = robots.map{|r| r.time_to_loop @wrap_limits}.reduce{|a,b|a.lcm(b)}

    time_to_loop.times do |i|
      new_pos = robots.map{|r| r.move(i)}

      if @generate_image
        png = ChunkyPNG::Image.new(101, 103, ChunkyPNG::Color::WHITE)
        new_pos.each do |pos|
          png[pos.column, pos.row] = ChunkyPNG::Color::BLACK
        end
        png.save("#{image_dir}/#{i}.png")
      end

      if @print_result
        puts " -- time #{i}"
        @wrap_limits.row.times do |row|
          @wrap_limits.column.times do |col|
            nr = new_pos.count(Coordinate.new(row, col))
            png[col,row] = nr == 0 ? ChunkyPNG::Color::WHITE : ChunkyPNG::Color::BLACK
            print(nr == 0 ? ?..colorize(:light_black) : nr.to_s.colorize(:green))
          end
          puts
        end
      end
    end

    if @generate_image
      puts 'Execution ended. Press enter to continue'
      print " #{image_dir} will be removed"
      gets
    end
  end
end

Star.new.help_the_elves

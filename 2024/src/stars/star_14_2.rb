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
  attr_writer :generate_image, :print_result

  def initialize n_rows=103, n_cols=101
    super(14, 2)
    @generate_image = true
    @print_result = true

    @n_rows = n_rows
    @n_cols = n_cols
  end

  def run(input)
    robots = []
    @wrap_limits = Coordinate.new(@n_rows, @n_cols)
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

    time_with_max_neighs = 0
    max_neighs = 0
    time_to_loop.times do |i|
      new_pos = Set.new robots.map{|r| r.move(i)}
      robots_with_neighbour = new_pos.count{|p| p.neighs.any?{|n| new_pos.include? n}}

      if robots_with_neighbour > max_neighs
        time_with_max_neighs = i
        max_neighs = robots_with_neighbour
      end
    end

    if @generate_image
      image_dir = Dir.mktmpdir('aoc_robots-')
      puts "Generating image in #{image_dir}"
      at_exit { FileUtils.remove_entry(image_dir) }

      png = ChunkyPNG::Image.new(101, 103, ChunkyPNG::Color::WHITE)
      robots.map{|r| r.move(time_with_max_neighs)}
            .each {|pos| png[pos.column, pos.row] = ChunkyPNG::Color::BLACK}
      png.save("#{image_dir}/#{time_with_max_neighs}.png")
    end

    if @print_result
      rs = robots.map{|r| r.move(time_with_max_neighs)}
      @wrap_limits.row.times do |row|
        @wrap_limits.column.times do |col|
          nr = rs.count(Coordinate.new(row, col))
          png[col,row] = nr == 0 ? ChunkyPNG::Color::WHITE : ChunkyPNG::Color::BLACK
          print(nr == 0 ? ?..colorize(:light_black) : nr.to_s.colorize(:green))
        end
        puts
      end
    end

    if @generate_image
      puts 'Execution ended. Press enter to continue'
      print " #{image_dir} will be removed"
      gets
    end

    time_with_max_neighs
  end
end

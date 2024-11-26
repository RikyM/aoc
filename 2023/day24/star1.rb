#!/usr/bin/env ruby

require 'numpy'

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Trajectory
  attr_reader :x0, :y0, :m
  def initialize x0, y0, vx, vy
    @x0 = x0
    @y0 = y0
    @vx = vx
    @vy = vy
    @m = @vy * 1.0 / @vx
  end
  
  def can_go? res
    @vx >= 0 ? res[0] >= @x0 : res[0] < @x0
  end

  def self.intersect a, b
    return nil if a.m == b.m

    p = [[-a.m, 1],
         [-b.m, 1]]
    s = [-(a.m * a.x0) + a.y0,
         -(b.m * b.x0) + b.y0]
    Numpy.linalg.solve(p, s).to_a
  end
end

trajectories = []

#MIN_COORD = 7
#MAX_COORD = 27

MIN_COORD = 200000000000000
MAX_COORD = 400000000000000

input.each_line do |l|
  starting, velocities = l.split(?@)

  x0, y0, _ = starting.split(', ').map(&:to_i)
  vx, vy, _ = velocities.split(', ').map(&:to_i)

  t = Trajectory.new(x0, y0, vx, vy)
  trajectories << t
end

count = 0
trajectories.combination(2).each do |a, b|
  log '------------'
  log a.inspect
  log b.inspect

  res = Trajectory.intersect a, b
  log res.inspect

  res = (not(res.nil?) and res.all?{|c| c >= MIN_COORD && c <= MAX_COORD} and a.can_go?(res) and b.can_go?(res))
  count += 1 if res
end

puts count

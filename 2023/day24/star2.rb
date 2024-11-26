#!/usr/bin/env ruby

require 'numpy'

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

class Trajectory
  attr_reader :x0, :y0, :eq
  def initialize x0, y0, z0, vx, vy, vz
    @x0 = x0
    @y0 = y0
    @z0 = z0
    @vx = vx
    @vy = vy
    @vz = vz

    @eq = [[@vx, -@vy,    0, (@vx * @x0) - (@vy * @y0)],
           [@vx,    0, -@vz, (@vx * @x0) - (@vz * @z0)]]
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

  def self.proj a, b
    log a.inspect
    log b.inspect
    Numpy.dot(b.eq, b.eq)
    #Numpy.dot(Numpy.dot(a, b) / Numpy.dot(b, b), b)
  end
end

trajectories = []

#MIN_COORD = 7
#MAX_COORD = 27

MIN_COORD = 200000000000000
MAX_COORD = 400000000000000

input.each_line do |l|
  starting, velocities = l.split(?@)

  x0, y0, z0 = starting.split(', ').map(&:to_i)
  vx, vy, vz = velocities.split(', ').map(&:to_i)

  t = Trajectory.new(x0, y0, z0, vx, vy, vz)
  trajectories << t
end

count = 0
trajectories.combination(2).each do |a, b|
  res = Trajectory.intersect a, b

  res = res.all?{|c| c >= MIN_COORD && c <= MAX_COORD}

  log res.inspect
end

puts count

#!/usr/bin/env ruby

X_MUL = 1000

input_file = ARGV[0]

input = File.read(input_file)

require 'set'

STEPS = 26501365

def log message
  STDERR.puts message
end

#class Coord
#  attr_reader :x, :y
#
#  def initialize x, y
#    @x = x
#    @y = y
#  end
#
#  def == other
#    @x == other.x and @y == other.y
#  end
#
#  def eql? other
#    self == other
#  end
#
#  def hash
#    [@x, @y].hash
#  end
#
#  def neighs 
#    [
#      Coord.new(@x+1, @y),
#      Coord.new(@x-1, @y),
#      Coord.new(@x, @y+1),
#      Coord.new(@x, @y-1)
#    ]
#  end
#
#  def to_s
#    "[#@x, #@y]"
#  end
#
#  def normalize max_x, max_y
#    return Coord.new @x%(max_x+1), @y%(max_y+1)
#  end
#
#  def out_of_bounds? max_x, max_y
#    @x < 0 or @y < 0 or @x > max_x or @y > max_y
#  end
#end

rocks = Set.new
start = nil

input.each_line.with_index do |row, y|
  row.each_char.with_index do |c,x|
    case c
    when ?#
      rocks.add (x * X_MUL) + y
    when ?S
      start = (x * X_MUL) + y
    end
  end
end

max_y = input.lines.size - 1
max_x = input.lines.first.chomp.size - 1

log max_y
log max_x

to_visit = [start]
seen = Set.new

count = 0

other_starts = []

$dist_memo = {}

def neighs coord, max_x, max_y
  in_coord = []
  out_coord = []

  x = coord / X_MUL
  y = coord % X_MUL

  if x == 0
    out_coord << (max_x * X_MUL) + y
  else
    in_coord << coord - X_MUL
  end

  if y == 0
    out_coord << (x * X_MUL) + max_y
  else
    in_coord << coord - 1
  end

  if x == max_x
    out_coord << y
  else
    in_coord << coord + X_MUL
  end

  if y == max_x
    out_coord << x
  else
    in_coord << coord + 1
  end

  {in: in_coord, out: out_coord}
end

def distances start, rocks, max_x, max_y
  res = $dist_memo[start]
  return res unless res.nil?

  #distances = {}
  #distances.default = 0
  distances = Array.new((max_x + max_y) * 2, 0)
  other_starts = []

  to_visit = [start]
  seen = Set.new
  seen.add start
  distances[0] = 1

  i = 1
  until to_visit.empty?
    new_to_visit = []

    to_visit.each do |patch|
      neighs = neighs(patch, max_x, max_y)

      neighs[:in].filter{|p| not(seen.include? p) and not(rocks.include? p) }.each do |n|
        new_to_visit << n
        seen.add n
        distances[i] += 1
      end

      neighs[:out].filter{|p| not(seen.include? p)}.each do |n|
        other_starts << {patch: n, taken_steps: i}
      end
    end

    i += 1
    to_visit = new_to_visit
  end

  res = {dist: distances, out: other_starts}
  $dist_memo[start] = res
  return res
end

d = 0
starts = [{patch: start, taken_steps: 0}]

target = 10

sum = 0
until starts.empty?
  start = starts.pop

  log start

  dist = distances start[:patch], rocks, max_x, max_y

  partial_target = target - start[:taken_steps]

  this_count = dist[:dist].filter.with_index{|n,i| (partial_target % 2 == i % 2) and i <= partial_target}.sum

  new_starts = dist[:out].each{|o| o[:taken_steps] += start[:taken_steps]}
  new_starts = dist[:out].filter{|o| o[:taken_steps] < partial_target}
  #log "  new_starts:"
  #new_starts.each{|s| log "     -> #{s}"}
  
  log "  -> #{this_count}"
  sum += this_count

  starts += new_starts
end

log sum

return

10.times do |i|
  new_to_visit = []

  to_visit.each do |patch|
    neighs = patch.neighs.filter{|p| not(seen.include? p) and not(rocks.include? p.normalize(max_y,max_x)) }
    neighs.each do |n|
      if n.out_of_bounds?(max_x, max_y)
        other_starts << {start: n.normalize(max_x, max_y), taken_steps: i}
      else
        new_to_visit << n
        seen.add n
        count += (i % 2)
      end
    end
  end

  to_visit = new_to_visit
end

log other_starts

puts count

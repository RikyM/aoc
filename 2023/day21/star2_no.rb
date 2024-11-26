#!/usr/bin/env ruby

X_MUL = 1000

input_file = ARGV[0]

input = File.read(input_file)

require 'set'

STEPS = 26501365

def log message
  STDERR.puts message
end


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

def neighs coord
  sign = coord / 1000
  coord_pos = coord >= 0

  [ coord - X_MUL,
    coord - 1,
    coord + X_MUL,
    coord + 1
  ]
  #.map{|c|
  #  c_pos = c >= 0
  #  if c_pos ^ coord_pos
  #    (c / 10000) == 1 ? c - 10000 : c + 10000
  #  else
  #    c
  #  end
  #}

end

#distances = Array.new((max_x + max_y) * 2, 0)
other_starts = []

to_visit = [start]
seen = Set.new
seen.add start

distances = {start => 1}
distances.default = 0
count = 1

def normalize p
  #p %= 10000
#  y = p % 1000
#  x = p / 1000
##
#  ((x % 11) * 1000) + (y%11)
end

log normalize -12000

#16733044
16.times do |i|
  new_to_visit = []

  to_visit.each do |patch|
    neighs = neighs(patch)
    neighs = neighs.filter{|p| not(rocks.include? normalize(p)) and not(distances.include? p)}
    neighs.each do |n|
      new_to_visit << n
      distances[n] += 1#1 if i.odd?
      #count += 1 if i.odd?
    end
  end

  to_visit = new_to_visit
end

log distances.values.sum

puts count

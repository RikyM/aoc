#!/usr/bin/env ruby

X_MUL = 1000

input_file = ARGV[0]

input = File.read(input_file)

require 'set'

STEPS = 26501365

def log message
  STDERR.puts message
end

#rocks = Set.new
start = nil

$adj = {}

def neighs x, y, max_x, max_y, input
  in_coord = []
  out_coord = []

  coord = (x * X_MUL) + y

  if x == 0
    out_coord[0] = (max_x * X_MUL) + y
  else
    in_coord << coord - X_MUL unless input[y][x-1] == ?#
  end

  if y == 0
    out_coord[1] = (x * X_MUL) + max_y
  else
    in_coord << coord - 1 unless input[y-1][x] == ?#
  end

  if x == max_x
    out_coord[2] = y
  else
    in_coord << coord + X_MUL unless input[y][x+1] == ?#
  end

  if y == max_x
    out_coord[3] = x
  else
    in_coord << coord + 1 unless input[y+1][x] == ?#
  end

  {in: in_coord, out: out_coord}
end

max_y = input.lines.size - 1
max_x = input.lines.first.chomp.size - 1

input.each_line.with_index do |row, y|
  row.each_char.with_index do |c,x|
    coord = (x * X_MUL) + y

    case c
    when ?#
      #rocks.add (x * X_MUL) + y
    when /[S.]/
      start = (x * X_MUL) + y if c == ?S

      $adj[coord] = neighs x, y, max_x, max_y, input.lines
    end
  end
end

# Build adj

log max_y
log max_x

to_visit = [start]
seen = Set.new

count = 0

other_starts = []

$dist_memo = {}

def distances start, max_x, max_y
  res = $dist_memo[start]
  return res unless res.nil?

  #distances = {}
  #distances.default = 0
  distances = []
  other_starts = []

  to_visit = [start]
  seen = Set.new
  seen.add start
  distances[0] = [start]

  i = 1
  until to_visit.empty?
    new_to_visit = []

    to_visit.each do |patch|
      neighs = $adj[patch]

      neighs[:in].filter{|p| not(seen.include? p) }.each do |n|
        new_to_visit << n
        seen.add n
        #distances[n] = i
      end
      distances[i] = new_to_visit

      neighs[:out].filter{|p| not(seen.include? p)}.each.with_index do |n, dir|
        other_starts << {patch: n, taken_steps: i, dir: dir} unless n.nil?
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

#        16733044
target = 10

sum = 0

reached = Set.new

grid_x = 0
grid_y = 0

until starts.empty?
  start = starts.pop

  log start

  dist = distances start[:patch], max_x, max_y

  partial_target = target - start[:taken_steps]

  #this_count = dist[:dist].filter.with_index{|n,i| (partial_target % 2 == i % 2) and i <= partial_target}.sum
  dist[:dist].filter.with_index{|d,i| (partial_target % 2 == i % 2) and i <= partial_target}
             .flatten
             .each{|d| reached.add d + (grid_y * 1000000) + (grid_x * 100000000)}
            
  log dist[:dist].filter.with_index{|d,i| (partial_target % 2 == i % 2) and i <= partial_target}.inspect

  new_starts = dist[:out].each{|o| o[:taken_steps] += start[:taken_steps]}
  new_starts = dist[:out].filter{|o| o[:taken_steps] < partial_target}
  #log "  new_starts:"
  #new_starts.each{|s| log "     -> #{s}"}
  
  #log "  -> #{this_count}"
  #sum += this_count

  starts += new_starts
end

log reached.size

return

#!/usr/bin/env ruby

require 'set'

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

max_y = input.lines.size - 1
max_x = input.lines.first.chomp.size - 1

log max_y
log max_x

adj = Hash.new{|h,k| h[k] = []}

forest = input.lines.map{|row| row.chomp.chars}

forest.each.with_index do |row,y|
  row.each.with_index do |c, x|
    next if c == ?#

    coord = (x * 1000) + y

    neighs = []

    if y > 0 and (c == '.' or c == '^') and forest[y-1][x] != ?# and forest[y-1][x] != 'v'
      neighs << coord - 1
    end

    if (c == '.' or c == '<') and forest[y][x-1] != ?# and forest[y-1][x] != '>'
      neighs << coord - 1000
    end

    if y < max_y and (c == '.' or c == 'v') and forest[y+1][x] != ?# and forest[y-1][x] != '^'
      neighs << coord + 1
    end

    if (c == '.' or c == '>') and forest[y][x+1] != ?# and forest[y-1][x] != '<'
      neighs << coord + 1000
    end

    adj[coord] = neighs
  end
end

start  = 1000
target = (max_x * 1000 + max_y) - 1000
log adj
log target

def longest start, target, steps, seen, adj
  return steps if start == target

  neighs = adj[start].filter{|n| not seen.include? n}

  case neighs.size
  when 0
    return 0
  when 1
    seen.add start
    return longest neighs[0], target, steps+1, seen, adj
  else
    return neighs.map{|n| longest n, target, steps+1, seen + [start], adj}.max
  end
    
end

res = longest start, target, 0, Set.new, adj

puts res

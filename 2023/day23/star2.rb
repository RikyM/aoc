#!/usr/bin/env ruby

require 'set'

input_file = ARGV[0]

input = File.read(input_file)

def log message
  STDERR.puts message
end

max_y = input.lines.size - 1
max_x = input.lines.first.chomp.size - 1

adj = Hash.new{|h,k| h[k] = []}

forest = input.lines.map{|row| row.chomp.chars}

forest.each.with_index do |row,y|
  row.each.with_index do |c, x|
    next if c == ?#

    coord = (x * 1000) + y

    neighs = []

    if y > 0 and forest[y-1][x] != ?#
      neighs << coord - 1
    end

    if c != ?# and forest[y][x-1] != ?#
      neighs << coord - 1000
    end

    if y < max_y and forest[y+1][x] != ?#
      neighs << coord + 1
    end

    if forest[y][x+1] != ?#
      neighs << coord + 1000
    end

    adj[coord] = neighs
  end
end

start  = 1000
target = (max_x * 1000 + max_y) - 1000

crossroads = adj.filter{|s,t| t.size != 2}.keys

cross_adj = {}

def explore start, prev, steps, adj
  ns = adj[start]
  if ns.size != 2
    return {target: start, steps: steps}
  end

  ns = ns.filter{|n| n != prev}.first
  return explore ns, start, steps+1, adj
end

crossroads.each do |c|
  cross_adj[c] = adj[c].map{|n| explore n, c, 1, adj}
end


def longest start, target, steps, seen, adj
  return steps if start == target

  neighs = adj[start].filter{|n| not seen.include? n[:target]}

  case neighs.size
  when 0
    return 0
  when 1
    seen.add start
    return longest neighs[0][:target], target, steps+neighs[0][:steps], seen, adj
  else
    return neighs.map{|n| longest n[:target], target, steps+n[:steps], seen + [start], adj}.max
  end
    
end

res = longest start, target, 0, Set.new, cross_adj

puts res
